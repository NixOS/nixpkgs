#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts jq

set -eox pipefail

here="$(dirname "${BASH_SOURCE[0]}")"
modules="${here}/modules"
srcs="${here}/srcs-generated.json"

while read -r module; do
    if [[ -z "$module" ]]; then continue; fi
    url="https://invent.kde.org/qt/qt/${module}.git"
    nix-prefetch-git --url $url --rev refs/heads/kde/5.15 --fetch-submodules \
        | jq "{key: \"${module}\", value: {url,rev,sha256}}"
done < "$modules" | jq -s 'from_entries' > "${srcs}.tmp"

mv "${srcs}.tmp" "$srcs"
