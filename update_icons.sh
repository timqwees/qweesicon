#!/bin/zsh

# Скрипт для замены иконок по точным совпадениям имен
# Логика: ищет точные совпадения имен файлов и заменяет их

# Пути
SOURCE_DIR="/Users/timqwees/Desktop/workspace/learn/qweesicon/new"
ICONS_DIR="/Users/timqwees/Desktop/workspace/learn/qweesicon/icons"

echo "Скрипт замены иконок по точным совпадениям..."
echo "Исходная папка: $SOURCE_DIR"
echo "Папка иконок: $ICONS_DIR"
echo ""

# Проверка существования папок
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: Папка $SOURCE_DIR не найдена"
    exit 1
fi

if [ ! -d "$ICONS_DIR" ]; then
    echo "Ошибка: Папка $ICONS_DIR не найдена"
    exit 1
fi

# Счетчики
copied_count=0
error_count=0
missing_files=""

# Функция для поиска файла в icons по имени
find_icon_in_icons() {
    local filename="$1"
    local found_path=""
    
    # Рекурсивный поиск файла с точным именем
    found_path=$(find "$ICONS_DIR" -name "$filename" -type f 2>/dev/null | head -1)
    
    if [ -n "$found_path" ]; then
        echo "$found_path"
        return 0
    fi
    return 1
}

echo "Обработка файлов..."
echo ""

# Обрабатываем файлы иконок
for source_file in "$SOURCE_DIR"/*.svg; do
    if [ ! -f "$source_file" ]; then
        continue
    fi
    
    filename=${source_file##*/}
    echo "Обрабатываю: $filename"
    
    # Ищем точное совпадение в папке icons
    if target_path=$(find_icon_in_icons "$filename"); then
        echo "Найдено совпадение: $target_path"
        
        # Удаляем старый файл
        rm "$target_path"
        echo "Удален старый файл: $target_path"
        
        # Копируем новый файл на то же место
        cp "$source_file" "$target_path"
        echo "Скопирован новый файл: $target_path"
        
        ((copied_count++))
    else
        echo "Не найдено совпадение для: $filename"
        ((error_count++))
        missing_files="$missing_files$filename\n"
    fi
    
    echo ""
done

echo "Итоги:"
echo "Заменено файлов: $copied_count"
echo "Ошибок (не найдено совпадений): $error_count"
echo ""

if [ $error_count -eq 0 ]; then
    echo "Все иконки успешно заменены!"
else
    echo "Замена завершена. Некоторым файлам не найдены совпадения."
    echo ""
    echo "Не найденные файлы:"
    echo -e "$missing_files"
fi

echo ""
echo "Проверка результатов..."
echo ""

# Показываем несколько случайных замененных файлов для проверки
if [ $copied_count -gt 0 ]; then
    echo "Проверка нескольких замененных файлов:"
    find "$ICONS_DIR" -name "file_type_*.svg" -type f | head -5 | while read file; do
        echo "$file"
    done
fi
