#!/bin/bash

trap '' INT

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"

while true; do
    echo -en "${RED}[?]${RESET} Enter Domain name                                 : "
    read domain

    echo -en "${RED}[?]${RESET}Do you want to run online module [Y/n]             : "
    read omodule

    echo -en "${RED}[?]${RESET}Do you want to subcast [Y/n]                       : "
    read subcast

    echo -en "${RED}[?]${RESET}Want to provide any wordlist [default/empty for no]: "
    read wordlist

    echo -en "${RED}[?]${RESET}Any IPs you want to exclude [comma-separated]      : "
    read excludelist

    echo -en "${RED}[?]${RESET}Specify Ports you want to scan [Empty to leave]    : "
    read ports

    echo -en "${RED}[?]${RESET}Number of threads to generate [25]                 : "
    read threads

    args="-d $domain -o /opt/subtakes/$domain/subdomains.txt --csv /opt/subtakes/$domain/report.csv --filter"

    if [ "$omodule" != "Y" ] && [ "$omodule" != "y" ]; then
        args="$args --skip-search"
    fi

    if [ "$subcast" != "Y" ] && [ "$subcast" != "y" ]; then
        args="$args --skip-subcast"
    else
        args="$args --only-sublister"
    fi

    if [ "$wordlist" != "" ]; then
        if [ "$wordlist" == "default" ]; then
        args="$args --wordlists /opt/SecLists/Discovery/DNS/subdomains-top1million-5000.txt"
        else
        args="$args --wordlists $wordlist"
        fi
    fi

    if [ "$excludelist" != "" ]; then
        args="$args --exclude-ips '$excludelist'"
    fi

    if [ "$ports" != "" ]; then
        args="$args --ports '$ports'"
    fi

    if [ "$threads" != "" ]; then
        args="$args --threads $threads"
    fi

    mkdir -p /opt/subtakes/$domain

    screen -S $domain -dm bash -c "subtakes $args; echo;; echo; echo "${MAGENTA}[-]${RESET} Press any key to continue..."; read; exit"
    screen -r $domain
    clear
done