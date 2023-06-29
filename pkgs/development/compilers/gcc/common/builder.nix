{ lib
, stdenv
, enableMultilib
}:

originalAttrs: (stdenv.mkDerivation (finalAttrs: originalAttrs //
(let
  inherit (finalAttrs) targetConfig;
  ifNullThen = val: default: if val==null then default else val;
  targetConfigSlash = if targetConfig==null then "" else "${targetConfig}/";
in {
  preUnpack = ''
    oldOpts="$(shopt -po nounset)" || true
    set -euo pipefail

    export NIX_FIXINC_DUMMY="$NIX_BUILD_TOP/dummy"
    mkdir "$NIX_FIXINC_DUMMY"

    if test "$staticCompiler" = "1"; then
        EXTRA_LDFLAGS="-static"
    else
        EXTRA_LDFLAGS="-Wl,-rpath,${builtins.placeholder "lib"}/lib"
    fi

    # GCC interprets empty paths as ".", which we don't want.
    if test -z "''${CPATH-}"; then unset CPATH; fi
    if test -z "''${LIBRARY_PATH-}"; then unset LIBRARY_PATH; fi
    echo "\$CPATH is \`''${CPATH-}'"
    echo "\$LIBRARY_PATH is \`''${LIBRARY_PATH-}'"

    if test "$noSysDirs" = "1"; then

        declare -g \
            EXTRA_FLAGS_FOR_BUILD EXTRA_FLAGS EXTRA_FLAGS_FOR_TARGET \
            EXTRA_LDFLAGS_FOR_BUILD EXTRA_LDFLAGS_FOR_TARGET

        # Extract flags from Bintools Wrappers
        for post in '_FOR_BUILD' ""; do
            curBintools="NIX_BINTOOLS''${post}"

            declare -a extraLDFlags=()
            if [[ -e "''${!curBintools}/nix-support/orig-libc" ]]; then
                # Figure out what extra flags when linking to pass to the gcc
                # compilers being generated to make sure that they use our libc.
                extraLDFlags=($(< "''${!curBintools}/nix-support/libc-ldflags") $(< "''${!curBintools}/nix-support/libc-ldflags-before" || true))
                if [ -e ''${!curBintools}/nix-support/ld-set-dynamic-linker ]; then
                    extraLDFlags=-dynamic-linker=$(< ''${!curBintools}/nix-support/dynamic-linker)
                fi

                # The path to the Libc binaries such as `crti.o'.
                libc_libdir="$(< "''${!curBintools}/nix-support/orig-libc")/lib"
            else
                # Hack: support impure environments.
                extraLDFlags=("-L/usr/lib64" "-L/usr/lib")
                libc_libdir="/usr/lib"
            fi
            extraLDFlags=("-L$libc_libdir" "-rpath" "$libc_libdir"
                          "''${extraLDFlags[@]}")
            for i in "''${extraLDFlags[@]}"; do
                declare -g EXTRA_LDFLAGS''${post}+=" -Wl,$i"
            done
        done

        # Extract flags from CC Wrappers
        for post in '_FOR_BUILD' ""; do
            curCC="NIX_CC''${post}"
            curFIXINC="NIX_FIXINC_DUMMY''${post}"

            declare -a extraFlags=()
            if [[ -e "''${!curCC}/nix-support/orig-libc" ]]; then
                # Figure out what extra compiling flags to pass to the gcc compilers
                # being generated to make sure that they use our libc.
                extraFlags=($(< "''${!curCC}/nix-support/libc-crt1-cflags") $(< "''${!curCC}/nix-support/libc-cflags"))

                # The path to the Libc headers
                libc_devdir="$(< "''${!curCC}/nix-support/orig-libc-dev")"

                # Use *real* header files, otherwise a limits.h is generated that
                # does not include Libc's limits.h (notably missing SSIZE_MAX,
                # which breaks the build).
                declare -g NIX_FIXINC_DUMMY''${post}="$libc_devdir/include"
            else
                # Hack: support impure environments.
                extraFlags=("-isystem" "/usr/include")
                declare -g NIX_FIXINC_DUMMY''${post}=/usr/include
            fi

            extraFlags=("-I''${!curFIXINC}" "''${extraFlags[@]}")

            # BOOT_CFLAGS defaults to `-g -O2'; since we override it below, make
            # sure to explictly add them so that files compiled with the bootstrap
            # compiler are optimized and (optionally) contain debugging information
            # (info "(gccinstall) Building").
            if test -n "''${dontStrip-}"; then
                extraFlags=("-O2" "-g" "''${extraFlags[@]}")
            else
                # Don't pass `-g' at all; this saves space while building.
                extraFlags=("-O2" "''${extraFlags[@]}")
            fi

            declare -g EXTRA_FLAGS''${post}="''${extraFlags[*]}"
        done

        if test -z "${ifNullThen targetConfig ""}"; then
            # host = target, so the flags are the same
            EXTRA_FLAGS_FOR_TARGET="$EXTRA_FLAGS"
            EXTRA_LDFLAGS_FOR_TARGET="$EXTRA_LDFLAGS"
        fi

        # CFLAGS_FOR_TARGET are needed for the libstdc++ configure script to find
        # the startfiles.
        # FLAGS_FOR_TARGET are needed for the target libraries to receive the -Bxxx
        # for the startfiles.
        makeFlagsArray+=(
            "BUILD_SYSTEM_HEADER_DIR=$NIX_FIXINC_DUMMY_FOR_BUILD"
            "SYSTEM_HEADER_DIR=$NIX_FIXINC_DUMMY_FOR_BUILD"
            "NATIVE_SYSTEM_HEADER_DIR=$NIX_FIXINC_DUMMY"

            "LDFLAGS_FOR_BUILD=$EXTRA_LDFLAGS_FOR_BUILD"
            #"LDFLAGS=$EXTRA_LDFLAGS"
            "LDFLAGS_FOR_TARGET=$EXTRA_LDFLAGS_FOR_TARGET"

            "CFLAGS_FOR_BUILD=$EXTRA_FLAGS_FOR_BUILD $EXTRA_LDFLAGS_FOR_BUILD"
            "CXXFLAGS_FOR_BUILD=$EXTRA_FLAGS_FOR_BUILD $EXTRA_LDFLAGS_FOR_BUILD"
            "FLAGS_FOR_BUILD=$EXTRA_FLAGS_FOR_BUILD $EXTRA_LDFLAGS_FOR_BUILD"

            # It seems there is a bug in GCC 5
            #"CFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"
            #"CXXFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"

            "CFLAGS_FOR_TARGET=$EXTRA_FLAGS_FOR_TARGET $EXTRA_LDFLAGS_FOR_TARGET"
            "CXXFLAGS_FOR_TARGET=$EXTRA_FLAGS_FOR_TARGET $EXTRA_LDFLAGS_FOR_TARGET"
            "FLAGS_FOR_TARGET=$EXTRA_FLAGS_FOR_TARGET $EXTRA_LDFLAGS_FOR_TARGET"
        )

        if test -z "${ifNullThen targetConfig ""}"; then
            makeFlagsArray+=(
                "BOOT_CFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"
                "BOOT_LDFLAGS=$EXTRA_FLAGS_FOR_TARGET $EXTRA_LDFLAGS_FOR_TARGET"
            )
        fi

        # We don't want the gcc build to assume there will be a libc providing
        # limits.h in this stage
        makeFlagsArray+=(
            'LIMITS_H_TEST=${lib.boolToString (!finalAttrs.withoutTargetLibc)}'
        )
    fi

    eval "$oldOpts"
  '';

  preConfigure = (originalAttrs.preConfigure or "") + ''
  '' + lib.optionalString (finalAttrs.newlibSrc or false) ''
    tar xvf "$newlibSrc" -C ..
    ln -s ../newlib-*/newlib newlib
    # Patch to get armvt5el working:
    sed -i -e 's/ arm)/ arm*)/' newlib/configure.host

  '' + ''
    # Bug - they packaged zlib
    if test -d "zlib"; then
        # This breaks the build without-headers, which should build only
        # the target libgcc as target libraries.
        # See 'configure:5370'
        rm -Rf zlib
    fi

  '' + lib.optionalString (finalAttrs.crossMingw && finalAttrs.withoutTargetLibc) ''
    mkdir -p ../mingw
    # --with-build-sysroot expects that:
    cp -R $libcCross/include ../mingw
    configureFlags="$configureFlags --with-build-sysroot=`pwd`/.."

  '' + ''
    # Perform the build in a different directory.
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';

  # Avoid store paths when embedding ./configure flags into gcc.
  # Mangled arguments are still useful when reporting bugs upstream.
  postConfigure = ''
    sed -e "/TOPLEVEL_CONFIGURE_ARGUMENTS=/ s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i Makefile
  '';

  preInstall = ''
    mkdir -p "$out/${ifNullThen targetConfig ""}/lib"
    mkdir -p "${builtins.placeholder "lib"}/${ifNullThen targetConfig ""}/lib"
  '' +
  # Make `lib64` symlinks to `lib`.
  lib.optionalString (!enableMultilib && stdenv.hostPlatform.is64bit && !stdenv.hostPlatform.isMips64n32) ''
    ln -s lib "$out/${ifNullThen targetConfig ""}/lib64"
    ln -s lib "${builtins.placeholder "lib"}/${ifNullThen targetConfig ""}/lib64"
  '' +
  # On mips platforms, gcc follows the IRIX naming convention:
  #
  #  $PREFIX/lib   = mips32
  #  $PREFIX/lib32 = mips64n32
  #  $PREFIX/lib64 = mips64
  #
  # Make `lib32` symlinks to `lib`.
  lib.optionalString (!enableMultilib && stdenv.targetPlatform.isMips64n32) ''
    ln -s lib "$out/${ifNullThen targetConfig ""}/lib32"
    ln -s lib "${builtins.placeholder "lib"}/${ifNullThen targetConfig ""}/lib32"
  '';

  # Move runtime libraries to lib output.
  postInstall = ''
    moveToOutput "${targetConfigSlash}lib/lib*.so*" "${builtins.placeholder "lib"}"
    moveToOutput "${targetConfigSlash}lib/lib*.la"  "${builtins.placeholder "lib"}"
    moveToOutput "${targetConfigSlash}lib/lib*.dylib" "${builtins.placeholder "lib"}"
    moveToOutput "${targetConfigSlash}lib/lib*.dll.a" "${builtins.placeholder "lib"}"
    moveToOutput "share/gcc-*/python" "${builtins.placeholder "lib"}"

  '' + lib.optionalString (!finalAttrs.enableShared) ''
    moveToOutput "${targetConfigSlash}lib/lib*.a" "${builtins.placeholder "lib"}"
  '' + ''

    for i in "${builtins.placeholder "lib"}/${ifNullThen targetConfig ""}"/lib/*.{la,py}; do
        substituteInPlace "$i" --replace "$out" "${builtins.placeholder "lib"}"
    done

    if [ -n "$enableMultilib" ]; then
        moveToOutput "${targetConfigSlash}lib64/lib*.so*" "${builtins.placeholder "lib"}"
        moveToOutput "${targetConfigSlash}lib64/lib*.la"  "${builtins.placeholder "lib"}"
        moveToOutput "${targetConfigSlash}lib64/lib*.dylib" "${builtins.placeholder "lib"}"

        for i in "${builtins.placeholder "lib"}/${ifNullThen targetConfig ""}"/lib64/*.{la,py}; do
            substituteInPlace "$i" --replace "$out" "${builtins.placeholder "lib"}"
        done
    fi

    # Remove `fixincl' to prevent a retained dependency on the
    # previous gcc.
    rm -rf $out/libexec/gcc/*/*/install-tools
    rm -rf $out/lib/gcc/*/*/install-tools

    # More dependencies with the previous gcc or some libs (gccbug stores the build command line)
    rm -rf $out/bin/gccbug

    if type "install_name_tool"; then
        for i in "${builtins.placeholder "lib"}"/lib/*.*.dylib "${builtins.placeholder "lib"}"/lib/*.so.[0-9]; do
            install_name_tool -id "$i" "$i" || true
            for old_path in $(otool -L "$i" | grep "$out" | awk '{print $1}'); do
              new_path=`echo "$old_path" | sed "s,$out,${builtins.placeholder "lib"},"`
              install_name_tool -change "$old_path" "$new_path" "$i" || true
            done
        done
    fi

    # Cross-compiler specific:
    # --with-headers=$dir option triggers gcc to make a private copy
    # of $dir headers and use it later as `-isysroot`. This prevents
    # cc-wrapper from overriding libc headers with `-idirafter`.
    # It should be safe to drop it and rely solely on the cc-wrapper.
    local sysinc_dir=$out/${targetConfigSlash}sys-include
    if [ -d "$sysinc_dir" ]; then
        chmod -R u+w "$out/${targetConfigSlash}sys-include"
        rm -rfv "$out/${targetConfigSlash}sys-include"
    fi

    # Get rid of some "fixed" header files
    rm -rfv $out/lib/gcc/*/*/include-fixed/{root,linux,sys/mount.h,bits/statx.h}

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
    for i in "$out"/share/man/man1/*g++.1; do
        if test -e "$i"; then
            man_prefix=`echo "$i" | sed "s,.*/\(.*\)g++.1,\1,"`
            ln -sf "$man_prefix"gcc.1 "$i"
        fi
    done
  '';
})))
