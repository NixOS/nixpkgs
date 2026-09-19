#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl

set -eou pipefail

version="$(
  curl -fsSL https://desktop.app.music.yandex.net/stable/latest-linux.yml |
    sed -n 's/^version: \(.*\)$/\1/p'
)"

update-source-version yandex-music "$version"
