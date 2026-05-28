#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix nix-prefetch-github

set -euo pipefail
echoerr() { echo "$@" 1>&2; }

fname="$1"
echoerr got fname $fname
shift
latest_release=$(curl --silent https://api.github.com/repos/EttusResearch/uhd/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release" | cut -c2-)
# Update version, if needed
if grep -q 'version = "'$version $fname; then
    echoerr Current version $version is the latest available
    exit 0;
fi
echoerr got version $version
sed -i -E 's/(version = ").*(";)/\1'$version'\2/g' $fname
# Verify the sed command above did not fail
grep -q $version $fname
# Update srcHash
srcHash="$(nix-prefetch-github EttusResearch uhd --rev v${version} | jq --raw-output .hash)"
sed -i -E 's#(hash = ").*(";)#\1'$srcHash'\2#g' $fname
grep -q $srcHash $fname
imageHash="$(nix-prefetch-url https://github.com/EttusResearch/uhd/releases/download/v${version}/uhd-images_${version}.tar.xz)"
sed -i -E 's#(sha256 = ").*(";)#\1'$imageHash'\2#g' $fname
grep -q $imageHash $fname
