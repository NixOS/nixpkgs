#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-update

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/stacklok/toolhive/releases/latest | jq -r .tag_name | sed 's/^v//')
currentVersion=$(nix eval --raw -f . toolhive.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "toolhive is up-to-date: $currentVersion"
    exit 0
fi

echo "Updating toolhive from $currentVersion to $latestVersion"
nix-update toolhive --version "$latestVersion"