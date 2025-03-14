#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl xq-xml common-updater-scripts

set -eu -o pipefail

version="$(curl https://www.jetbrains.com/youtrack/update.xml | \
    xq -x "/products/product[@name='YouTrack']/channel/build/@version")"

update-source-version youtrack "$version"
