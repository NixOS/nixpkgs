#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts gnused zon2nix

set -e

latest_tag=$(list-git-tags --url=https://codeberg.org/ifreund/waylock | sed 's/^v//' | tail -n 1)

update-source-version waylock "$latest_tag"

wget "https://codeberg.org/ifreund/waylock/raw/tag/v${latest_tag}/build.zig.zon"
zon2nix build.zig.zon >pkgs/by-name/wa/waylock/build.zig.zon.nix
nixfmt pkgs/by-name/wa/waylock/build.zig.zon.nix

rm -f build.zig.zon build.zig.zon2json-lock
