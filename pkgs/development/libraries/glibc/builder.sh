# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1

. $stdenv/setup


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
    configureFlags="--enable-add-ons --disable-profile"
}

preConfigure=preConfigure


postInstall() {
    make localedata/install-locales
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
}

postInstall=postInstall


genericBuild
