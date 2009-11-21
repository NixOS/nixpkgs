source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


# libstdc++ needs this; otherwise it will use /lib/cpp, which is a Bad
# Thing.
export CPP="gcc -E"


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


    extraCFlags="-g0 -I$gmp/include -I$mpfr/include $extraCFlags"
    extraLDFlags="--strip-debug $extraLDFlags"

    export NIX_EXTRA_CFLAGS=$extraCFlags
    for i in $extraLDFlags; do
        export NIX_EXTRA_LDFLAGS="$NIX_EXTRA_LDFLAGS -Wl,$i"
    done

    if test -n "$crossConfig"; then
        if test -z "$crossStageStatic"; then
            extraXCFlags="-B${glibcCross}/lib -idirafter ${glibcCross}/include"
            extraXLDFlags="-L${glibcCross}/lib"
            export NIX_EXTRA_CFLAGS_TARGET=$extraXCFlags
            for i in $extraXLDFlags; do
                export NIX_EXTRA_LDFLAGS_TARGET="$NIX_EXTRA_LDFLAGS_TARGET -Wl,$i"
            done
        fi

        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
            SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
            CFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS_TARGET $NIX_EXTRA_LDFLAGS_TARGET" \
            LDFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS_TARGET $NIX_EXTRA_LDFLAGS_TARGET" \
            )
    else
        export NIX_EXTRA_CFLAGS_TARGET=$NIX_EXTRA_CFLAGS
        export NIX_EXTRA_LDFLAGS_TARGET=$NIX_EXTRA_LDFLAGS
        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
            SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
            CFLAGS_FOR_BUILD="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
            CFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
            LDFLAGS_FOR_BUILD="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
            LDFLAGS_FOR_TARGET="$NIX_EXTRA_CFLAGS $NIX_EXTRA_LDFLAGS" \
            )
    fi

    if test -n "$crossConfig" -a "$crossStageStatic" == 1; then
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

if test -n "$crossConfig"; then
    # The host strip will destroy everything in the target binaries otherwise
    dontStrip=1
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


if test -z "$crossConfig"; then
    if test -z "$profiledCompiler"; then
        buildFlags="bootstrap $buildFlags"
    else    
        buildFlags="profiledbootstrap $buildFlags"
    fi
else
:
#    buildFlags="all-gcc all-target-libgcc $buildFlags"
#    installTargets="install-gcc install-target-libgcc"
fi

genericBuild
