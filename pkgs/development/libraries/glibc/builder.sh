# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
export NIX_DONT_SET_RPATH=1

source $stdenv/setup
source $substitute

glibc=`cat $NIX_GCC/nix-support/orig-glibc`
echo $glibc

export LD_LIBRARY_PATH=$glibc/lib

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)


postUnpack=postUnpack
postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
    rm -rf nptl
    cd ..
}


preConfigure=preConfigure
preConfigure() {

    # Use Linuxthreads instead of NPTL.
    rm -rf nptl

    for i in configure io/ftwtest-sh; do
        substituteInPlace "$i" \
            --replace "@PWD@" "pwd"
    done

    mkdir ../build
    cd ../build
    
    configureScript=../$sourceRoot/configure
    # `--with-tls --without-__thread' enables support for TLS but
    # causes it not to be used.  Required if we don't want to barf on
    # 2.4 kernels.  Or something.
    configureFlags="--enable-add-ons \
      --with-headers=$kernelHeaders/include
      --with-tls --without-__thread"
}


postConfigure=postConfigure
postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=
}


postInstall=postInstall
postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
    fi
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
}


genericBuild
