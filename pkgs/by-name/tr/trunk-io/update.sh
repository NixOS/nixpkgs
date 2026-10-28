#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre2 common-updater-scripts

set -eu -o pipefail

version="$(curl -fsSL https://trunk.io/releases/trunk | grep -Fi 'readonly TRUNK_LAUNCHER_VERSION=' | pcre2grep -o1 '"(\d+(?:\.\d+)+)"')"
update-source-version trunk-io "$version"
