#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts nixfmt zon2nix

latest_tag=$(list-git-tags --url=https://git.sr.ht/~novakane/zelbar | sed 's/^v//' | tail -n 1)

update-source-version zelbar "$latest_tag"

wget "https://git.sr.ht/~novakane/zelbar/blob/v${latest_tag}/build.zig.zon"
zon2nix build.zig.zon >pkgs/by-name/ze/zelbar/build.zig.zon.nix
nixfmt pkgs/by-name/ze/zelbar/build.zig.zon.nix

rm -f build.zig.zon build.zig.zon2json-lock
