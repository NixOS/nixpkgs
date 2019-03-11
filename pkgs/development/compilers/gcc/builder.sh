source $stdenv/setup


oldOpts="$(shopt -po nounset)" || true
set -euo pipefail


export NIX_FIXINC_DUMMY="$NIX_BUILD_TOP/dummy"
mkdir "$NIX_FIXINC_DUMMY"


if test "$staticCompiler" = "1"; then
    EXTRA_LDFLAGS="-static"
else
    EXTRA_LDFLAGS="-Wl,-rpath,${!outputLib}/lib"
fi


# GCC interprets empty paths as ".", which we don't want.
if test -z "${CPATH-}"; then unset CPATH; fi
if test -z "${LIBRARY_PATH-}"; then unset LIBRARY_PATH; fi
echo "\$CPATH is \`${CPATH-}'"
echo "\$LIBRARY_PATH is \`${LIBRARY_PATH-}'"

if test "$noSysDirs" = "1"; then

    declare \
        EXTRA_BUILD_FLAGS EXTRA_FLAGS EXTRA_TARGET_FLAGS \
        EXTRA_BUILD_LDFLAGS EXTRA_TARGET_LDFLAGS

    # Extract flags from Bintools Wrappers
    for pre in 'BUILD_' ''; do
        curBintools="NIX_${pre}BINTOOLS"

        declare -a extraLDFlags=()
        if [[ -e "${!curBintools}/nix-support/orig-libc" ]]; then
            # Figure out what extra flags when linking to pass to the gcc
            # compilers being generated to make sure that they use our libc.
            extraLDFlags=($(< "${!curBintools}/nix-support/libc-ldflags") $(< "${!curBintools}/nix-support/libc-ldflags-before" || true))

            # The path to the Libc binaries such as `crti.o'.
            libc_libdir="$(< "${!curBintools}/nix-support/orig-libc")/lib"
        else
            # Hack: support impure environments.
            extraLDFlags=("-L/usr/lib64" "-L/usr/lib")
            libc_libdir="/usr/lib"
        fi
        extraLDFlags=("-L$libc_libdir" "-rpath" "$libc_libdir"
                      "${extraLDFlags[@]}")
        for i in "${extraLDFlags[@]}"; do
            declare EXTRA_${pre}LDFLAGS+=" -Wl,$i"
        done
    done

    # Extract flags from CC Wrappers
    for pre in 'BUILD_' ''; do
        curCC="NIX_${pre}CC"
        curFIXINC="NIX_${pre}FIXINC_DUMMY"

        declare -a extraFlags=()
        if [[ -e "${!curCC}/nix-support/orig-libc" ]]; then
            # Figure out what extra compiling flags to pass to the gcc compilers
            # being generated to make sure that they use our libc.
            extraFlags=($(< "${!curCC}/nix-support/libc-cflags"))

            # The path to the Libc headers
            libc_devdir="$(< "${!curCC}/nix-support/orig-libc-dev")"

            # Use *real* header files, otherwise a limits.h is generated that
            # does not include Libc's limits.h (notably missing SSIZE_MAX,
            # which breaks the build).
            declare NIX_${pre}FIXINC_DUMMY="$libc_devdir/include"
        else
            # Hack: support impure environments.
            extraFlags=("-isystem" "/usr/include")
            declare NIX_${pre}FIXINC_DUMMY=/usr/include
        fi

        extraFlags=("-I${!curFIXINC}" "${extraFlags[@]}")

        # BOOT_CFLAGS defaults to `-g -O2'; since we override it below, make
        # sure to explictly add them so that files compiled with the bootstrap
        # compiler are optimized and (optionally) contain debugging information
        # (info "(gccinstall) Building").
        if test -n "${dontStrip-}"; then
            extraFlags=("-O2" "-g" "${extraFlags[@]}")
        else
            # Don't pass `-g' at all; this saves space while building.
            extraFlags=("-O2" "${extraFlags[@]}")
        fi

        declare EXTRA_${pre}FLAGS="${extraFlags[*]}"
    done

    if test -z "${targetConfig-}"; then
        # host = target, so the flags are the same
        EXTRA_TARGET_FLAGS="$EXTRA_FLAGS"
        EXTRA_TARGET_LDFLAGS="$EXTRA_LDFLAGS"
    fi

    # CFLAGS_FOR_TARGET are needed for the libstdc++ configure script to find
    # the startfiles.
    # FLAGS_FOR_TARGET are needed for the target libraries to receive the -Bxxx
    # for the startfiles.
    makeFlagsArray+=(
        "BUILD_SYSTEM_HEADER_DIR=$NIX_BUILD_FIXINC_DUMMY"
        "SYSTEM_HEADER_DIR=$NIX_BUILD_FIXINC_DUMMY"
        "NATIVE_SYSTEM_HEADER_DIR=$NIX_FIXINC_DUMMY"

        "LDFLAGS_FOR_BUILD=$EXTRA_BUILD_LDFLAGS"
        #"LDFLAGS=$EXTRA_LDFLAGS"
        "LDFLAGS_FOR_TARGET=$EXTRA_TARGET_LDFLAGS"

        "CFLAGS_FOR_BUILD=$EXTRA_BUILD_FLAGS $EXTRA_BUILD_LDFLAGS"
        "CXXFLAGS_FOR_BUILD=$EXTRA_BUILD_FLAGS $EXTRA_BUILD_LDFLAGS"
        "FLAGS_FOR_BUILD=$EXTRA_BUILD_FLAGS $EXTRA_BUILD_LDFLAGS"

        # It seems there is a bug in GCC 5
        #"CFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"
        #"CXXFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"

        "CFLAGS_FOR_TARGET=$EXTRA_TARGET_FLAGS $EXTRA_TARGET_LDFLAGS"
        "CXXFLAGS_FOR_TARGET=$EXTRA_TARGET_FLAGS $EXTRA_TARGET_LDFLAGS"
        "FLAGS_FOR_TARGET=$EXTRA_TARGET_FLAGS $EXTRA_TARGET_LDFLAGS"
    )

    if test -z "${targetConfig-}"; then
        makeFlagsArray+=(
            "BOOT_CFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"
            "BOOT_LDFLAGS=$EXTRA_TARGET_FLAGS $EXTRA_TARGET_LDFLAGS"
        )
    fi

    if test "$crossStageStatic" == 1; then
        # We don't want the gcc build to assume there will be a libc providing
        # limits.h in this stagae
        makeFlagsArray+=(
            'LIMITS_H_TEST=false'
        )
    else
        makeFlagsArray+=(
            'LIMITS_H_TEST=true'
        )
    fi
fi

if test -n "${targetConfig-}"; then
    # The host strip will destroy some important details of the objects
    dontStrip=1
fi

eval "$oldOpts"

providedPreConfigure="$preConfigure";
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

    if test -f "$NIX_CC/nix-support/orig-libc"; then
        # Patch the configure script so it finds glibc headers.  It's
        # important for example in order not to get libssp built,
        # because its functionality is in glibc already.
        sed -i \
            -e "s,glibc_header_dir=/usr/include,glibc_header_dir=$libc_dev/include", \
            gcc/configure
    fi

    if test -n "$crossMingw" -a -n "$crossStageStatic"; then
        mkdir -p ../mingw
        # --with-build-sysroot expects that:
        cp -R $libcCross/include ../mingw
        configureFlags="$configureFlags --with-build-sysroot=`pwd`/.."
    fi

    # Eval the preConfigure script from nix expression.
    eval "$providedPreConfigure"

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
    # Make ‘lib64’ symlinks to ‘lib’.
    if [ -n "$is64bit" -a -z "$enableMultilib" ]; then
        mkdir -p "$out/lib"
        ln -s lib "$out/lib64"
        mkdir -p "$lib/lib"
        ln -s lib "$lib/lib64"
    fi
}


postInstall() {
    # Move runtime libraries to $lib.
    moveToOutput "lib/lib*.so*" "$lib"
    moveToOutput "lib/lib*.la"  "$lib"
    moveToOutput "lib/lib*.dylib" "$lib"
    moveToOutput "share/gcc-*/python" "$lib"

    for i in "$lib"/lib/*.{la,py}; do
        substituteInPlace "$i" --replace "$out" "$lib"
    done

    if [ -n "$enableMultilib" ]; then
        moveToOutput "lib64/lib*.so*" "$lib"
        moveToOutput "lib64/lib*.la"  "$lib"
        moveToOutput "lib64/lib*.dylib" "$lib"

        for i in "$lib"/lib64/*.{la,py}; do
            substituteInPlace "$i" --replace "$out" "$lib"
        done
    fi

    # Remove `fixincl' to prevent a retained dependency on the
    # previous gcc.
    rm -rf $out/libexec/gcc/*/*/install-tools
    rm -rf $out/lib/gcc/*/*/install-tools

    # More dependencies with the previous gcc or some libs (gccbug stores the build command line)
    rm -rf $out/bin/gccbug

    if type "patchelf"; then
        # Take out the bootstrap-tools from the rpath, as it's not needed at all having $out
        for i in $(find "$out"/libexec/gcc/*/*/* -type f -a \! -name '*.la'); do
            PREV_RPATH=`patchelf --print-rpath "$i"`
            NEW_RPATH=`echo "$PREV_RPATH" | sed 's,:[^:]*bootstrap-tools/lib,,g'`
            patchelf --set-rpath "$NEW_RPATH" "$i" && echo OK
        done

        # For some reason the libs retain RPATH to $out
        for i in "$lib"/lib/{libtsan,libasan,libubsan}.so.*.*.*; do
            PREV_RPATH=`patchelf --print-rpath "$i"`
            NEW_RPATH=`echo "$PREV_RPATH" | sed "s,:${out}[^:]*,,g"`
            patchelf --set-rpath "$NEW_RPATH" "$i" && echo OK
        done
    fi

    if type "install_name_tool"; then
        for i in "$lib"/lib/*.*.dylib; do
            install_name_tool -id "$i" "$i" || true
            for old_path in $(otool -L "$i" | grep "$out" | awk '{print $1}'); do
              new_path=`echo "$old_path" | sed "s,$out,$lib,"`
              install_name_tool -change "$old_path" "$new_path" "$i" || true
            done
        done
    fi

    # Get rid of some "fixed" header files
    rm -rfv $out/lib/gcc/*/*/include-fixed/{root,linux}

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

    # Two identical man pages are shipped (moving and compressing is done later)
    ln -sf gcc.1 "$out"/share/man/man1/g++.1
}

genericBuild
