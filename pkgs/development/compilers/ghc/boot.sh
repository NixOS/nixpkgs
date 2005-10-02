source $stdenv/setup

postBuild=postBuild
postBuild () {
    glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
    find . -type f -perm +100 \
        -exec patchelf --interpreter $glibc/lib/ld-linux.so.* \
        --set-rpath "$readline/lib:$ncurses/lib" {} \;
}

genericBuild
