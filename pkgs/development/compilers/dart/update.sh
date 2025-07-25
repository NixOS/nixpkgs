#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

latestVersion=$(curl -sL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | jq --raw-output .version)
currentVersion=$(nix eval --raw -f . dart.version)

if [[ "$latestVersion" == "$currentVersion" ]]; then
  exit 0
fi

MY_PATH=$(dirname $(realpath "$0"))

update-source-version dart $latestVersion --file=$MY_PATH/sources.nix

systems=$(nix eval --json -f . dart.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
  hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . dart.src.url --system "$system")))
  update-source-version dart $latestVersion $hash --file=$MY_PATH/sources.nix --system=$system --ignore-same-version --ignore-same-hash
done
