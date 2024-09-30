#! /bin/sh

source lib-cache.sh;

module_name="$1";
module_basename="${1//::/-}";

print_requirements () {
    module_name="$1";

    ./retrieve-meta-yaml.sh "$module_name" |
        sed -re '1,/^requires:/d; /^[a-z]/,$d; s@^\s*@@; s@:\s.*@@';
    ./retrieve-meta-yaml.sh "$module_name" |
        sed -re '1,/^build_requires:/d; /^[a-z]/,$d; s@^\s*@@; s@:\s.*@@';
};

cached_output print_requirements "$module_basename" "$module_name" "direct.deps";
