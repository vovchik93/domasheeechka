#!/bin/bash

# Функция для вывода справки
function show_help() {
    echo "Использование: $0 [OPTIONS]"
    echo "OPTIONS:"
    echo "  -u, --users       Показать перечень пользователей и их домашних директорий."
    echo "  -p, --processes   Показать перечень запущенных процессов."
    echo "  -h, --help        Показать эту справку."
    echo "  -l PATH, --log PATH     Записать вывод в файл по указанному пути."
    echo "  -e PATH, --errors PATH   Записать ошибки в файл по указанному пути."
}

# Функция для вывода пользователей
function list_users() {
    if [[ -n "$log_file" ]]; then
        getent passwd | awk -F: '{print $1 ": " $6}' | sort > "$log_file" 2>/dev/null
    else
        getent passwd | awk -F: '{print $1 ": " $6}' | sort
    fi
}

# Функция для вывода процессов
function list_processes() {
    if [[ -n "$log_file" ]]; then
        ps -eo pid,comm --sort=pid > "$log_file" 2>/dev/null
    else
        ps -eo pid,comm --sort=pid
    fi
}

# Обработка аргументов командной строки
log_file=""
error_file=""

while [[ "$1" != "" ]]; do
    case $1 in
        -u | --users )      list_users
                            exit
                            ;;
        -p | --processes )  list_processes
                            exit
                            ;;
        -h | --help )       show_help
                            exit
                            ;;
        -l )                shift
                            log_file="$1"
                            ;;
        --log )             shift
                            log_file="$1"
                            ;;
        -e )                shift
                            error_file="$1"
                            ;;
        --errors )          shift
                            error_file="$1"
                            ;;
        * )                 echo "Неизвестный параметр: $1"
                            show_help
                            exit 1
    esac
    shift
done

# Переадресация ошибок, если указан путь для ошибок
if [[ -n "$error_file" ]]; then
    exec 2>>"$error_file"
fi
