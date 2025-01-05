#! /bin/sh

source lib-cache.sh;

print_reqs() {
    module_name="$1";

    ./requirements.sh "$1"| while read; do
        if let "$(./source-download-link.sh "${REPLY}" | wc -c)" && [ perl != "$REPLY" ]; then
            echo "$REPLY";
        fi;
    done;
}

module_name="$1";
module_basename="${module_name//::/-}";

cached_output print_reqs "$module_basename" "$module_name" "pure.deps";
