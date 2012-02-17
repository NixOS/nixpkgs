source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


if test "$noSysDirs" = "1"; then

    if test -e $NIX_GCC/nix-support/orig-libc; then

        # Figure out what extra flags to pass to the gcc compilers
        # being generated to make sure that they use our glibc.
        extraCFlags="$(cat $NIX_GCC/nix-support/libc-cflags)"
        extraLDFlags="$(cat $NIX_GCC/nix-support/libc-ldflags) $(cat $NIX_GCC/nix-support/libc-ldflags-before)"

        # Use *real* header files, otherwise a limits.h is generated
        # that does not include Glibc's limits.h (notably missing
        # SSIZE_MAX, which breaks the build).
        export NIX_FIXINC_DUMMY=$(cat $NIX_GCC/nix-support/orig-libc)/include
        
    else
        # Hack: support impure environments.
        extraCFlags="-isystem /usr/include"
        extraLDFlags="-L/usr/lib64 -L/usr/lib"
        export NIX_FIXINC_DUMMY=/usr/include
    fi

    export NIX_EXTRA_CFLAGS=$extraCFlags
    for i in $extraLDFlags; do
        export NIX_EXTRA_LDFLAGS="$NIX_EXTRA_LDFLAGS -Wl,$i"
    done        
    export CFLAGS=$extraCFlags
    export CXXFLAGS=$extraCFlags
fi


preConfigure() {
    # Perform the build in a different directory.
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
}


postInstall() {
    # Remove precompiled headers for now.  They are very big and
    # probably not very useful yet.
    find $out/include -name "*.gch" -exec rm -rf {} \; -prune

    # Remove `fixincl' to prevent a retained dependency on the
    # previous gcc.
    rm -rf $out/libexec/gcc/*/*/install-tools
}


if test -z "$profiledCompiler"; then
    buildFlags="bootstrap $buildFlags"
else    
    buildFlags="profiledbootstrap $buildFlags"
fi

genericBuild
