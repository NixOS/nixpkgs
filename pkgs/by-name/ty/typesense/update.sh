#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch common-updater-scripts nix coreutils moreutils
# shellcheck shell=bash

set -euo pipefail

latestVersion=$(curl -sL "https://api.github.com/repos/typesense/typesense/releases/latest" | jq --raw-output ".tag_name" | sed 's/^v//')
currentVersion=$(nix eval --raw -f . typesense.version)

if [[ "$latestVersion" == "$currentVersion" ]]; then
  exit 0
fi

MY_PATH=$(dirname $(realpath "$0"))

jq --arg version "$latestVersion" '.version = $version' $MY_PATH/sources.json | sponge $MY_PATH/sources.json

systems=$(nix eval --json -f . typesense.meta.platforms | jq --raw-output '.[]')
for system in $systems; do
  hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . typesense.src.url --system "$system")))
  jq --arg system "$system" --arg hash "$hash" '.platforms[$system].hash = $hash' $MY_PATH/sources.json | sponge $MY_PATH/sources.json
done
