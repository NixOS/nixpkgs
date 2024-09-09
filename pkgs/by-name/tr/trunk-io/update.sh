#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -eu -o pipefail

version="$(curl -fsSL https://trunk.io/releases/trunk | grep -Fi 'readonly TRUNK_LAUNCHER_VERSION=' | pcregrep -o1 '"(\d+(?:\.\d+)+)"')"
update-source-version trunk-io "$version"
