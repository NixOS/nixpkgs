source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


# libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
# Thing.
export CPP="gcc -E"

if test "$staticCompiler" = "1"; then
    EXTRA_LDFLAGS="-static"
else
    EXTRA_LDFLAGS=""
fi

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

	# The path to the Glibc binaries such as `crti.o'.
	glibc_libdir="$(cat $NIX_GCC/nix-support/orig-libc)/lib"
        
    else
        # Hack: support impure environments.
        extraCFlags="-isystem /usr/include"
        extraLDFlags="-L/usr/lib64 -L/usr/lib"
	glibc_libdir="/usr/lib"
        export NIX_FIXINC_DUMMY=/usr/include
    fi

    # Setting $CPATH makes sure both `gcc' and `xgcc' find the C
    # library headers, regarless of the language being compiled.
    export CPATH="$NIX_FIXINC_DUMMY:$gmp/include:$mpfr/include"

    # Likewise, to help it find `crti.o' and similar files.
    export LIBRARY_PATH="$glibc_libdir"

    if test "$langJava" = "1"; then
	for lib in "$zlib" "$boehmgc" "$libX11" "$libXt" "$libSM" \
	    "$libICE" "$libXtst"
	do
	    if test -n "$lib"
	    then
		export CPATH="$CPATH:$lib/include"
		export LIBRARY_PATH="$LIBRARY_PATH:$lib/lib"
	    fi
	done
    fi

    echo "setting \$CPATH to \`$CPATH'"
    echo "setting \$LIBRARY_PATH to \`$LIBRARY_PATH'"


    extraCFlags="-g0 $extraCFlags"
    extraLDFlags="--strip-debug $extraLDFlags"

    for i in $extraLDFlags; do
        export EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,$i"
    done

    makeFlagsArray=( \
        "${makeFlagsArray[@]}" \
        NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        LIMITS_H_TEST=true \
        X_CFLAGS="$extraCflags $EXTRA_LDFLAGS" \
        LDFLAGS="$extraCflags $EXTRA_LDFLAGS" \
        LDFLAGS_FOR_TARGET="$extraCflags $EXTRA_LDFLAGS" \
        )
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
    rm -rf $out/lib/gcc/*/*/install-tools

    # Get rid of some "fixed" header files
    rm -rf $out/lib/gcc/*/*/include/root

    # Replace hard links for i686-pc-linux-gnu-gcc etc. with symlinks.
    for i in $out/bin/*-gcc*; do
        if cmp -s $out/bin/gcc $i; then
            ln -sfn gcc $i
        fi
    done

    for i in $out/bin/*-c++* $out/bin/*-g++*; do
        if cmp -s $out/bin/g++ $i; then
            ln -sfn g++ $i
        fi
    done
}


if test -z "$profiledCompiler"; then
    buildFlags="bootstrap $buildFlags"
else    
    buildFlags="profiledbootstrap $buildFlags"
fi

genericBuild
