source $stdenv/setup

if test -n "$libdvdcss"; then
    # Ugly hack to force libdvdcss to be present (so the user doesn't
    # have to set LD_LIBRARY_PATH).
    export NIX_LDFLAGS="-rpath $libdvdcss/lib -L$libdvdcss/lib -ldvdcss $NIX_LDFLAGS"
fi

if test -n "$libXv"; then
    configureFlags="--with-xv-path=$libXv/lib $configureFlags"
fi

genericBuild