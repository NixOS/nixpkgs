#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq
# shellcheck shell=bash

set -e

pushd "$(dirname "$0")" &>/dev/null || exit 1

if [ "$1" == '' ]; then
    echo "Please select a group: 'packages', 'images', 'addons', 'extras', or 'licenses'" >&2
    exit 1
fi

namespace="$1"

if [ "$namespace" == 'licenses' ]; then
    jq -r '.licenses | keys | join("\n")' < repo.json
else
    jq -r --arg NAMESPACE "$namespace" \
        '.[$NAMESPACE] | paths as $path | getpath($path) as $v | select($path[-1] == "displayName") | [[$NAMESPACE] + $path[:-1] | map("\"" + . + "\"") | join("."), $v] | join(": ")' \
        < repo.json
fi

popd &>/dev/null
