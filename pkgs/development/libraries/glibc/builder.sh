# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1

. $stdenv/setup


# !!! Toss the linker flags.  Any sort of rpath is fatal.
# This probably will cause a failure when building in a pure Nix
# environment.
export NIX_LDFLAGS=
export NIX_GLIBC_FLAGS_SET=1


postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
    cd ..
}

postUnpack=postUnpack


preConfigure() {
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
    configureFlags="--enable-add-ons --disable-profile \
      --with-headers=$kernelHeaders/include"
}

preConfigure=preConfigure


postInstall() {
    make localedata/install-locales
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
}

postInstall=postInstall


genericBuild
