#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl bash nix-update common-updater-scripts nix

set -euo pipefail

current=$(nix-instantiate --eval -E "with import ./. {}; wootility.version or (lib.getVersion wootility.version)" | tr -d '"')
latest=$(curl -sL https://wooting.io/wootility/changelogs | grep -Po '(?<={"latestVersion":")[0-9]+\.[0-9]+\.[0-9]+(?="})')

if [[ "$current" == "$latest" ]]; then
    echo "package is up-to-date: $current"
    exit 0
fi

update-source-version wootility $latest || true

for system in \
  x86_64-linux \
  aarch64-linux \
  aarch64-darwin; do
  hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix-instantiate --eval -E "with import ./. {}; wootility.src.url" --system "$system" | tr -d '"')))
  update-source-version wootility $latest $hash --system=$system --ignore-same-version
done
