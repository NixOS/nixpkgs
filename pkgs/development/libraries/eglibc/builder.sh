# Glibc cannot have itself in its RPATH.
export NIX_NO_SELF_RPATH=1

source $stdenv/setup

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)

# Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
# prevent a retained dependency on the bootstrap tools in the
# stdenv-linux bootstrap.
export BASH_SHELL=/bin/sh

preConfigure() {

    for i in libc/configure libc/io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    # Include source for debugging
    mkdir -p $out/src
    cp -R libc ports $out/src
    ln -s $out/src/ports $out/src/libc/ports
    # glibc wants -O2 minimum
    export CFLAGS="-pipe -g -O2"

    mkdir $NIX_BUILD_TOP/build
    cd $NIX_BUILD_TOP/build
    
    configureScript=$out/src/libc/configure
}


postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=

    export NIX_DONT_SET_RPATH=1
    unset CFLAGS
}


postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
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
