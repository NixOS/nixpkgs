#! /bin/sh

source lib-cache.sh

get_file() {
    url="$1";

    if [ -n "$url" ]; then
        curl "$1";
    else
        echo -n;
    fi;
}

url="$1";
name="$2";
name=${name:-$(basename "$url")}

cached_output get_file "${name%%.*}" "$url" "${name#*.}"
