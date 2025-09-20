#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash

set -x

currentVersion=$(
    nix-instantiate --eval -E "with import ./. {}; typst-full.version or (lib.getVersion typst-full)" \
        | tr -d '"'
)

packageMeta="pkgs/by-name/ty/typst/typst-packages-from-universe.toml"
packageNix="pkgs/by-name/ty/typst-full/package.nix"

maintainers/scripts/update-typst-packages.py --output $packageMeta > /dev/null || exit 1

currentDate=$(date -u +%F)
latestVersion="0-unstable-${currentDate}"

if [[ "$currentVersion" != "$latestVersion" ]]; then
    currentVersionEscaped=$(echo "$currentVersion" | sed -re 's|[.+]|\\&|g')
    latestVersionEscaped=$(echo "$latestVersion" | sed -re 's|[.+]|\\&|g')

    sed -i.cmp "$packageNix" -re "/\bversion\b\s*=/ s|\"$currentVersionEscaped\"|\"$latestVersionEscaped\"|"
    if cmp -s "$nixFile" "$nixFile.cmp"; then
        echo "Failed to replace version '$currentVersion' to '$latestVersion' in '$packageNix'!"
        exit 1
    fi

    echo "[{\"attrPath\":\"typst-full\",\
\"oldVersion\":\"$currentVersion\",\
\"newVersion\":\"$latestVersion\",\
\"files\":[\"$packageMeta\",\"$packageNix\"]}]"
fi
