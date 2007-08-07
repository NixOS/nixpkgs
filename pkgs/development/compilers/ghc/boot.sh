source $stdenv/setup

postBuild=postBuild
postBuild () {
    find . -type f -perm +100 \
        -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "$readline/lib:$ncurses/lib:$gmp/lib" {} \;
}

genericBuild
