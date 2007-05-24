# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
export NIX_DONT_SET_RPATH=1

source $stdenv/setup

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)


postUnpack=postUnpack
postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
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

    # Workaround for the wrong <semaphore.h> getting installed.  This
    # appears to be a regression:
    # http://www.mail-archive.com/debian-glibc@lists.debian.org/msg31543.html
    cp ../$sourceRoot/linuxthreads/semaphore.h $out/include

    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi
}


genericBuild
