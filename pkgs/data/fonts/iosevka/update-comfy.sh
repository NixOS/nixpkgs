#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

repo=protesilaos/iosevka-comfy
oldVersion=$(nix-instantiate --eval -E 'with import ../../../.. {}; lib.getVersion iosevka-comfy.comfy' | tr -d \")
version=$(curl -s https://api.github.com/repos/$repo/tags | jq '.[0].name' | tr -d \")
buildPlansUrl=https://raw.githubusercontent.com/$repo/$(echo $version)/private-build-plans.toml

if test "$oldVersion" = "$version"; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

sed --in-place "s/$oldVersion/$version/" comfy.nix

cat  > ./comfy-private-build-plans.toml <<EOF
# The file below is copy/pasted from
# $buildPlansUrl. It
# seems like ofborg will prevent me from using fetchurl to download
# this file automatically.
EOF

wget --quiet --output-document=- "$buildPlansUrl" >> ./comfy-private-build-plans.toml

sets=$(grep '^\[buildPlans\.iosevka-comfy[^.]*\]' comfy-private-build-plans.toml \
           | sed 's/^.*iosevka-\(comfy[^]]*\)].*$/"\1" /' \
           | tr -d '\n' \
           | sort)

sed --in-place "s/sets = .*$/sets = [ $sets];/" comfy.nix
