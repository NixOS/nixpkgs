#!/usr/bin/env nix-shell
#!nix-shell -i bash -p "ruby.withPackages (pkgs: with pkgs; [ slop nokogiri moreutils ])"

set -e

pushd "$(dirname "$0")" &>/dev/null || exit 1

echo "Writing repo.json" >&2
cat ./repo.json | ruby mkrepo.rb \
    --packages ./xml/repository2-1.xml \
    --images ./xml/android-sys-img2-1.xml \
    --images ./xml/android-tv-sys-img2-1.xml \
    --images ./xml/android-wear-cn-sys-img2-1.xml \
    --images ./xml/android-wear-sys-img2-1.xml \
    --images ./xml/google_apis-sys-img2-1.xml \
    --images ./xml/google_apis_playstore-sys-img2-1.xml \
    --addons ./xml/addon2-1.xml \
         | sponge repo.json

popd &>/dev/null
