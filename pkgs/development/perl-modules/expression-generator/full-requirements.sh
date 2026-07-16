#! /bin/sh

source lib-cache.sh;

print_requirements () {
    module_name="$1";

    ./requirements.sh "$module_name" | while read; do
        echo "$REPLY";
        print_reqs_cache "$REPLY";
    done | sort | uniq
};

print_reqs_cache () {
    module_name="$1";
    module_basename="${module_name//::/-}";

    cached_output print_requirements "$module_basename" "$module_name" "full.deps";
};

print_reqs_cache "$@";
