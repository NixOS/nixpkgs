#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl

# We use this script to download local copies instead of using
# fetchpatch because lmhouse/MINGW-packages-dev is constantly rebased
# against msys2/MINGW-packages-dev and won't have stable commit hashes.

name=Added-mcf-thread-model-support-from-mcfgthread.patch
source=https://raw.githubusercontent.com/lhmouse/MINGW-packages-dev/master/mingw-w64-gcc-git
dest=$(dirname "$0")

for majorVersion in 6 7 8 9 10; do
    curl "$source/9000-gcc-$majorVersion-branch-$name" \
         > "$dest/$majorVersion/$name"
done
