#!/usr/bin/env nix-shell
#!nix-shell -p nix-update -i bash
# shellcheck shell=bash

set -o errexit -o pipefail -o nounset -o errtrace
shopt -s inherit_errexit
shopt -s nullglob
IFS=$'\n'

NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"

cd "$NIXPKGS_ROOT"
nix-update pipewire
outputs=$(nix-build . -A pipewire -A pipewire.mediaSession)
for p in $outputs; do
    conf_files=$(find "$p/nix-support/etc/pipewire/" -name '*.conf.json')
    for c in $conf_files; do
        file_name=$(basename "$c")
        if [[ ! -e "nixos/modules/services/desktops/pipewire/$file_name" ]]; then
            echo "New file $file_name found! Add it to the module config and passthru tests!"
        fi
        install -m 0644 "$c" "nixos/modules/services/desktops/pipewire/"
    done
done
