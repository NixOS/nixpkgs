source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


# libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
# Thing.
export CPP="gcc -E"

if test "$staticCompiler" = "1"; then
    NIX_EXTRA_LDFLAGS="-static"
else
    NIX_EXTRA_LDFLAGS=""
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

    extraCFlags="-g0 -O2 -I$NIX_FIXINC_DUMMY $extraCFlags"
    extraLDFlags="--strip-debug -L$glibc_libdir -rpath $glibc_libdir $extraLDFlags"

    export NIX_EXTRA_CFLAGS="$extraCFlags"
    for i in $extraLDFlags; do
        export NIX_EXTRA_LDFLAGS="$NIX_EXTRA_LDFLAGS -Wl,$i"
    done

    if test -n "$targetConfig"; then
        # Cross-compiling, we need gcc not to read ./specs in order to build
        # the g++ compiler (after the specs for the cross-gcc are created).
        # Having LIBRARY_PATH= makes gcc read the specs from ., and the build
        # breaks. Having this variable comes from the default.nix code to bring
        # gcj in.
        unset LIBRARY_PATH
        unset CPATH
        if test -z "$crossStageStatic"; then
            export NIX_EXTRA_CFLAGS_TARGET="-g0 -O2 -B${libcCross}/lib -idirafter ${libcCross}/include"
            export NIX_EXTRA_LDFLAGS_TARGET="-Wl,-L${libcCross}/lib"
        fi
    else
        # To be read by configure scripts (libtool-glibc.patch)
        export NIX_EXTRA_CFLAGS_TARGET="$NIX_EXTRA_CFLAGS"
        export NIX_EXTRA_LDFLAGS_TARGET="$NIX_EXTRA_LDFLAGS"
    fi

    makeFlagsArray=( \
        "${makeFlagsArray[@]}" \
        NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        CFLAGS_FOR_BUILD="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
        CFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS_TARGET $NIX_EXTRA_LDFLAGS_TARGET" \
        LDFLAGS_FOR_BUILD="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
        LDFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS_TARGET $NIX_EXTRA_LDFLAGS_TARGET" \
        )

    if test -z "$targetConfig"; then
        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            BOOT_CFLAGS="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
            BOOT_LDFLAGS="$NIX_EXTRA_CFLAGS_TARGET $NIX_EXTRA_LDFLAGS_TARGET" \
            )
    fi

    if test -n "$targetConfig" -a "$crossStageStatic" == 1; then
        # We don't want the gcc build to assume there will be a libc providing
        # limits.h in this stagae
        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            LIMITS_H_TEST=false \
            )
    else
        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            LIMITS_H_TEST=true \
            )
    fi
fi

if test -n "$targetConfig"; then
    # The host strip will destroy some important details of the objects
    dontStrip=1
fi

preConfigure() {
    if test -n "$newlibSrc"; then
        tar xvf "$newlibSrc" -C ..
        ln -s ../newlib-*/newlib newlib
        # Patch to get armvt5el working:
        sed -i -e 's/ arm)/ arm*)/' newlib/configure.host
    fi
    # Bug - they packaged zlib
    if test -d "zlib"; then
        # This breaks the build without-headers, which should build only
        # the target libgcc as target libraries.
        # See 'configure:5370'
        rm -Rf zlib
    fi

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


if test -z "$targetConfig"; then
    if test -z "$profiledCompiler"; then
        buildFlags="bootstrap $buildFlags"
    else    
        buildFlags="profiledbootstrap $buildFlags"
    fi
fi

genericBuild
