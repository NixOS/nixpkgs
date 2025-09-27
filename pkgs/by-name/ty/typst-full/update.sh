#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix

set -euxo pipefail

currentVersion=$(nix eval --raw --file . typst-full.version)
packageMeta="pkgs/by-name/ty/typst/typst-packages-from-universe.toml"
packageNix="pkgs/by-name/ty/typst-full/package.nix"

maintainers/scripts/update-typst-packages.py --output $packageMeta > /dev/null

currentDate=$(date -u +%F)
latestVersion="0-unstable-${currentDate}"

if [[ "$currentVersion" != "$latestVersion" ]]; then
    currentVersionEscaped=$(echo "$currentVersion" | sed -re 's|[.+]|\\&|g')
    latestVersionEscaped=$(echo "$latestVersion" | sed -re 's|[.+]|\\&|g')

    sed -i.cmp "$packageNix" -re "/\bversion\b\s*=/ s|\"$currentVersionEscaped\"|\"$latestVersionEscaped\"|"
    if cmp -s "$packageNix" "$packageNix.cmp"; then
        echo "Failed to replace version '$currentVersion' to '$latestVersion' in '$packageNix'!"
        exit 1
    fi

    echo "[{\"attrPath\":\"typst-full\",\
\"oldVersion\":\"$currentVersion\",\
\"newVersion\":\"$latestVersion\",\
\"files\":[\"$packageMeta\",\"$packageNix\"]}]"
fi
