#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion wiki-js_2" | tr -d '"')"
latestTag="$(git ls-remote --tags --sort="v:refname" https://github.com/Requarks/wiki-v2.git | tail -1 | awk '{ print $2 }' | sed -E "s,^refs/tags/v(.*)$,\1,")"

targetVersion="${1:-$latestTag}"
if [ ! "${oldVersion}" = "${targetVersion}" ]; then
  update-source-version wiki-js_2 "${targetVersion}"
  nix-build -A wiki-js_2
else
  echo "wiki-js is already up-to-date"
fi
