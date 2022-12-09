#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq
set -euo pipefail

RELEASE=$(curl "https://api.github.com/repos/Dreamacro/maxmind-geoip/releases/latest")
update-source-version clash-geoip "$(echo $RELEASE | jq -r .tag_name)"
