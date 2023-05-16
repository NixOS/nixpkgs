#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p "ruby.withPackages (pkgs: with pkgs; [ slop nokogiri moreutils ])"
=======
#!nix-shell -i bash -p "ruby.withPackages (pkgs: with pkgs; [ slop nokogiri ])"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

set -e

pushd "$(dirname "$0")" &>/dev/null || exit 1

echo "Writing repo.json" >&2
<<<<<<< HEAD
cat ./repo.json | ruby mkrepo.rb \
=======
ruby mkrepo.rb \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    --packages ./xml/repository2-1.xml \
    --images ./xml/android-sys-img2-1.xml \
    --images ./xml/android-tv-sys-img2-1.xml \
    --images ./xml/android-wear-cn-sys-img2-1.xml \
    --images ./xml/android-wear-sys-img2-1.xml \
    --images ./xml/google_apis-sys-img2-1.xml \
    --images ./xml/google_apis_playstore-sys-img2-1.xml \
<<<<<<< HEAD
    --addons ./xml/addon2-1.xml \
         | sponge repo.json
=======
    --addons ./xml/addon2-1.xml > repo.json
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

popd &>/dev/null
