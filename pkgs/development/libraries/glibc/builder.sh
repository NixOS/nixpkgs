# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
#export NIX_DEBUG=1
export NIX_DONT_SET_RPATH=1

. $stdenv/setup

glibc=`cat $NIX_GCC/nix-support/orig-glibc`
echo $glibc

export LD_LIBRARY_PATH=$glibc/lib

ourpwd=/nix/store/570ce2f39dcb7a75ac0793a1a73fd0b2-coreutils/bin/pwd
export PWD_P=$ourpwd

postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
    rm -rf nptl
    cd ..
}

#postUnpack=postUnpack


preConfigure() {
    . $subst
    echo "PATH:" $PATH
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
    # `--with-tls --without-__thread' is required when for
    # linuxthreads.  See
    # http://sources.redhat.com/bugzilla/show_bug.cgi?id=317.  Be sure
    # to read Drepper's comment for another classic example of glibc's
    # release management strategy.
    #configureFlags="--enable-add-ons --disable-profile \
    #  --with-headers=$kernelHeaders/include \
    #  --with-tls --without-__thread"
    #configureFlags="--enable-add-ons --disable-profile \
    #  --with-tls --with-headers=$kernelHeaders/include"
    configureFlags="--enable-add-ons \
      --with-headers=$kernelHeaders/include"
}

preConfigure=preConfigure

postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
    fi
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
    # `glibcbug' causes a retained dependency on the C compiler.
    #rm $out/bin/glibcbug
}

postInstall=postInstall


genericBuild
