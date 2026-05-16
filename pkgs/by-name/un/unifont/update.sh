#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

latest=$(curl -sL "https://ftp.gnu.org/gnu/unifont/" | grep -oP 'unifont-\K\d+\.\d+\.\d+' | sort -V | tail -1)

update-source-version unifont "$latest" --ignore-same-version --source-key=otf
update-source-version unifont "$latest" --ignore-same-version --source-key=pcf
update-source-version unifont "$latest" --ignore-same-version --source-key=bdf
