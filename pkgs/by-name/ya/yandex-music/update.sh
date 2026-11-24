#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl

set -eou pipefail

version="$(
  curl -fsSL https://desktop.app.music.yandex.net/stable/latest-linux.yml |
    sed -n 's/^version: \(.*\)$/\1/p'
)"

update-source-version yandex-music "$version" --system=x86_64-linux

darwin_url="https://desktop.app.music.yandex.net/stable/Yandex_Music_universal_${version}.dmg"
darwin_hash="$(nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --type sha256 "$darwin_url")")"

sed -i "/darwinSrc = fetchurl {/,/};/ s|hash = \".*\";|hash = \"${darwin_hash}\";|" \
  pkgs/by-name/ya/yandex-music/package.nix
