# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1

. $stdenv/setup


postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
    rm -rf nptl
    cd ..
}

postUnpack=postUnpack


preConfigure() {
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
    # `--with-tls --without-__thread' is required when for
    # linuxthreads.  See
    # http://sources.redhat.com/bugzilla/show_bug.cgi?id=317.  Be sure
    # to read Drepper's comment for another classic example of glibc's
    # release management strategy.
    configureFlags="--enable-add-ons --disable-profile \
      --with-headers=$kernelHeaders/include \
      --with-tls --without-__thread"
}

preConfigure=preConfigure


postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
    fi
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
    # `glibcbug' causes a retained dependency on the C compiler.
    rm $out/bin/glibcbug
}

postInstall=postInstall


genericBuild
