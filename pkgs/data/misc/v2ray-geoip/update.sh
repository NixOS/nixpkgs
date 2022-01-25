#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq
set -euo pipefail

COMMIT=$(curl "https://api.github.com/repos/v2fly/geoip/commits/release?per_page=1")
update-source-version v2ray-geoip "$(echo $COMMIT | jq -r .commit.message)" --file=pkgs/data/misc/v2ray-geoip/default.nix --rev="$(echo $COMMIT | jq -r .sha)"
