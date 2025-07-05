#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash

changes=()
currentVersion=$(
    nix-instantiate --eval -E "with import ./. {}; typst-full.version or (lib.getVersion typst-full)" \
        | tr -d '"'
)

maintainers/scripts/update-typst-packages.py \
    --output pkgs/by-name/ty/typst/typst-packages-from-universe.toml > /dev/null || exit 1

latestVersion=$(
    nix-instantiate --eval -E "with import ./. {}; typst-full.version or (lib.getVersion typst-full)" \
        | tr -d '"'
)

if [[ "$currentVersion" != "$latestVersion" ]]; then
    changes+=("{\"attrPath\":\"typst-full\",\
\"oldVersion\":\"$currentVersion\",\
\"newVersion\":\"$latestVersion\",\
\"files\":[\"pkgs/by-name/ty/typst/typst-packages-from-universe.toml\"]}"
    )
fi

echo -n "["
IFS=,; echo -n "${changes[*]}"
echo "]"
