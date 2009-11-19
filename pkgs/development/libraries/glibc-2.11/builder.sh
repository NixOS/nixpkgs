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

    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    # In the glibc 2.6/2.7 tarballs C-translit.h is a little bit older
    # than C-translit.h.in, forcing Make to rebuild it unnecessarily.
    # This wouldn't be problem except that it requires Perl, which we
    # don't want as a dependency in the Nixpkgs bootstrap.  So force
    # the output file to be newer.
    touch locale/C-translit.h

    if test -n "$crossConfig"; then
        sed -i s/-lgcc_eh//g Makeconfig
    fi

    mkdir build
    cd build
    
    configureScript=../configure
    if test -n "$crossConfig"; then
        cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF
        export BUILD_CC=gcc
        export CC="${crossConfig}-gcc"
        export AR="${crossConfig}-ar"
        export RANLIB="${crossConfig}-ranlib"
        configureFlags="${configureFlags} --cache-file=config.cache"

        # The host stripp will destroy everything in the target binaries otherwise
        dontStrip=1
    fi
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
    test -f $out/etc/ld.so.cache && rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1

    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi
}


genericBuild
