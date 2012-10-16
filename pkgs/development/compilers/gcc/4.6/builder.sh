source $stdenv/setup


export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
mkdir $NIX_FIXINC_DUMMY


if test "$staticCompiler" = "1"; then
    EXTRA_LDFLAGS="-static"
else
    EXTRA_LDFLAGS=""
fi

# GCC interprets empty paths as ".", which we don't want.
if test -z "$CPATH"; then unset CPATH; fi
if test -z "$LIBRARY_PATH"; then unset LIBRARY_PATH; fi
echo "\$CPATH is \`$CPATH'"
echo "\$LIBRARY_PATH is \`$LIBRARY_PATH'"

if test "$noSysDirs" = "1"; then

    if test -e $NIX_GCC/nix-support/orig-libc; then

        # Figure out what extra flags to pass to the gcc compilers
        # being generated to make sure that they use our glibc.
        extraFlags="$(cat $NIX_GCC/nix-support/libc-cflags)"
        extraLDFlags="$(cat $NIX_GCC/nix-support/libc-ldflags) $(cat $NIX_GCC/nix-support/libc-ldflags-before)"

        # Use *real* header files, otherwise a limits.h is generated
        # that does not include Glibc's limits.h (notably missing
        # SSIZE_MAX, which breaks the build).
        export NIX_FIXINC_DUMMY=$(cat $NIX_GCC/nix-support/orig-libc)/include

        # The path to the Glibc binaries such as `crti.o'.
        glibc_libdir="$(cat $NIX_GCC/nix-support/orig-libc)/lib"
        
    else
        # Hack: support impure environments.
        extraFlags="-isystem /usr/include"
        extraLDFlags="-L/usr/lib64 -L/usr/lib"
        glibc_libdir="/usr/lib"
        export NIX_FIXINC_DUMMY=/usr/include
    fi

    extraFlags="-I$NIX_FIXINC_DUMMY $extraFlags"
    extraLDFlags="-L$glibc_libdir -rpath $glibc_libdir $extraLDFlags"

    # BOOT_CFLAGS defaults to `-g -O2'; since we override it below,
    # make sure to explictly add them so that files compiled with the
    # bootstrap compiler are optimized and (optionally) contain
    # debugging information (info "(gccinstall) Building").
    if test -n "$dontStrip"; then
	extraFlags="-O2 -g $extraFlags"
    else
	# Don't pass `-g' at all; this saves space while building.
	extraFlags="-O2 $extraFlags"
    fi

    EXTRA_FLAGS="$extraFlags"
    for i in $extraLDFlags; do
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,$i"
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
            EXTRA_TARGET_CFLAGS="-B${libcCross}/lib -idirafter ${libcCross}/include"
            EXTRA_TARGET_LDFLAGS="-Wl,-L${libcCross}/lib"
        fi
    else
        if test -z "$NIX_GCC_CROSS"; then
            EXTRA_TARGET_CFLAGS="$EXTRA_FLAGS"
            EXTRA_TARGET_LDFLAGS="$EXTRA_LDFLAGS"
        else
            # This the case of cross-building the gcc.
            # We need special flags for the target, different than those of the build
            # Assertion:
            test -e $NIX_GCC_CROSS/nix-support/orig-libc

            # Figure out what extra flags to pass to the gcc compilers
            # being generated to make sure that they use our glibc.
            extraFlags="$(cat $NIX_GCC_CROSS/nix-support/libc-cflags)"
            extraLDFlags="$(cat $NIX_GCC_CROSS/nix-support/libc-ldflags) $(cat $NIX_GCC_CROSS/nix-support/libc-ldflags-before)"

            # Use *real* header files, otherwise a limits.h is generated
            # that does not include Glibc's limits.h (notably missing
            # SSIZE_MAX, which breaks the build).
            NIX_FIXINC_DUMMY_CROSS=$(cat $NIX_GCC_CROSS/nix-support/orig-libc)/include

            # The path to the Glibc binaries such as `crti.o'.
            glibc_libdir="$(cat $NIX_GCC_CROSS/nix-support/orig-libc)/lib"

            extraFlags="-I$NIX_FIXINC_DUMMY_CROSS $extraFlags"
            extraLDFlags="-L$glibc_libdir -rpath $glibc_libdir $extraLDFlags"

            EXTRA_TARGET_CFLAGS="$extraFlags"
            for i in $extraLDFlags; do
                EXTRA_TARGET_LDFLAGS="$EXTRA_TARGET_LDFLAGS -Wl,$i"
            done
        fi
    fi


    # CFLAGS_FOR_TARGET are needed for the libstdc++ configure script to find
    # the startfiles.
    # FLAGS_FOR_TARGET are needed for the target libraries to receive the -Bxxx
    # for the startfiles.
    makeFlagsArray=( \
        "${makeFlagsArray[@]}" \
        NATIVE_SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        SYSTEM_HEADER_DIR="$NIX_FIXINC_DUMMY" \
        CFLAGS_FOR_BUILD="$EXTRA_FLAGS $EXTRA_LDFLAGS" \
        CFLAGS_FOR_TARGET="$EXTRA_TARGET_CFLAGS $EXTRA_TARGET_LDFLAGS" \
        FLAGS_FOR_TARGET="$EXTRA_TARGET_CFLAGS $EXTRA_TARGET_LDFLAGS" \
        LDFLAGS_FOR_BUILD="$EXTRA_FLAGS $EXTRA_LDFLAGS" \
        LDFLAGS_FOR_TARGET="$EXTRA_TARGET_LDFLAGS $EXTRA_TARGET_LDFLAGS" \
        )

    if test -z "$targetConfig"; then
        makeFlagsArray=( \
            "${makeFlagsArray[@]}" \
            BOOT_CFLAGS="$EXTRA_FLAGS $EXTRA_LDFLAGS" \
            BOOT_LDFLAGS="$EXTRA_TARGET_CFLAGS $EXTRA_TARGET_LDFLAGS" \
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

    if test -f "$NIX_GCC/nix-support/orig-libc"; then
        # Patch the configure script so it finds glibc headers.  It's
        # important for example in order not to get libssp built,
        # because its functionality is in glibc already.
        glibc_headers="$(cat $NIX_GCC/nix-support/orig-libc)/include"
        sed -i \
            -e "s,glibc_header_dir=/usr/include,glibc_header_dir=$glibc_headers", \
            gcc/configure
    fi

    if test -n "$crossMingw" -a -n "$crossStageStatic"; then
        mkdir -p ../mingw
        # --with-build-sysroot expects that:
        cp -R $libcCross/include ../mingw
        configureFlags="$configureFlags --with-build-sysroot=`pwd`/.."
    fi

    # Perform the build in a different directory.
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
}


postConfigure() {
    # Don't store the configure flags in the resulting executables.
    sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile
}


preInstall() {
    # Make ‘lib64’ a symlink to ‘lib’.
    if [ -n "$is64bit" ]; then
        mkdir -p $out/lib
        ln -s lib $out/lib64
    fi
}


postInstall() {
    # Remove precompiled headers for now.  They are very big and
    # probably not very useful yet.
    find $out/include -name "*.gch" -exec rm -rf {} \; -prune

    # Remove `fixincl' to prevent a retained dependency on the
    # previous gcc.
    rm -rf $out/libexec/gcc/*/*/install-tools
    rm -rf $out/lib/gcc/*/*/install-tools
    
    # More dependencies with the previous gcc or some libs (gccbug stores the build command line)
    rm -rf $out/bin/gccbug
    # Take out the bootstrap-tools from the rpath, as it's not needed at all having $out
    for i in $out/libexec/gcc/*/*/*; do
        if PREV_RPATH=`patchelf --print-rpath $i`; then
            patchelf --set-rpath `echo $PREV_RPATH | sed 's,:[^:]*bootstrap-tools/lib,,'` $i
        fi
    done

    # Get rid of some "fixed" header files
    rm -rf $out/lib/gcc/*/*/include/root

    # Replace hard links for i686-pc-linux-gnu-gcc etc. with symlinks.
    for i in $out/bin/*-gcc*; do
        if cmp -s $out/bin/gcc $i; then
            ln -sfn gcc $i
        fi
    done

    for i in $out/bin/c++ $out/bin/*-c++* $out/bin/*-g++*; do
        if cmp -s $out/bin/g++ $i; then
            ln -sfn g++ $i
        fi
    done

    eval "$postInstallGhdl"
}


if test -z "$targetConfig" && test -z "$crossConfig"; then
    if test -z "$profiledCompiler"; then
        buildFlags="bootstrap $buildFlags"
    else    
        buildFlags="profiledbootstrap $buildFlags"
    fi
fi

genericBuild
