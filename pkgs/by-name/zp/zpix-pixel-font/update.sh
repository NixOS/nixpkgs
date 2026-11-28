#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix coreutils gnused
#shellcheck shell=bash

set -euo pipefail
cd "$(dirname "$0")/../../../.."

package="zpix-pixel-font"

current_version=$(nix-instantiate --eval --expr "with import ./. {}; ${package}.version" --raw)

curl_args=(--silent --fail --location)
if [ -n "${GITHUB_TOKEN:-}" ]; then
  curl_args+=(--user ":${GITHUB_TOKEN}")
fi

latest_version=$(curl "${curl_args[@]}" \
    "https://api.github.com/repos/SolidZORO/zpix-pixel-font/releases/latest" |
  jq --raw-output '.tag_name' | sed 's/^v//')

if [ "${current_version}" = "${latest_version}" ]; then
  echo "${package} is up to date: ${current_version}"
  exit 0
fi

echo "Updating ${package} from ${current_version} to ${latest_version}..."

update-source-version "${package}" "${latest_version}" --source-key=srcs.bdf
update-source-version "${package}" "${latest_version}" --ignore-same-version --source-key=srcs.ttf
