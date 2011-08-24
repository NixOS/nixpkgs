# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1

source $stdenv/setup

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)


postUnpack() {
    cd $sourceRoot/..
}


preConfigure() {

    for i in configure io/ftwtest-sh; do
        substituteInPlace "$i" \
            --replace "@PWD@" "pwd"
    done

    # Fix shell code that tries to determine whether GNU ld is recent enough.
    substituteInPlace configure --replace '2.1[3-9]*)' '2.1[3-9]*|2.[2-9][0-9]*)'

    mkdir ../build
    cd ../build

    configureScript=../$sourceRoot/configure
}


postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=
    export NIX_DONT_SET_RPATH=1
}


postInstall() {
    if test -n "$installLocales"; then
        make -j${NIX_BUILD_CORES:-1} -l${NIX_BUILD_CORES:-1} localedata/install-locales
    fi
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1

    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi
}


genericBuild
