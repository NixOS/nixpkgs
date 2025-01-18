{
  lib,
  stdenv,
  enableMultilib,
  targetConfig,
}:

let
  forceLibgccToBuildCrtStuff = import ./libgcc-buildstuff.nix { inherit lib stdenv; };
in

originalAttrs:
(stdenv.mkDerivation (
  finalAttrs:
  originalAttrs
  // {
    passthru = (originalAttrs.passthru or { }) // {
      inherit forceLibgccToBuildCrtStuff;
    };
    preUnpack = ''
      oldOpts="$(shopt -po nounset)" || true
      set -euo pipefail

      export NIX_FIXINC_DUMMY="$NIX_BUILD_TOP/dummy"
      mkdir "$NIX_FIXINC_DUMMY"

      if test "$staticCompiler" = "1"; then
          EXTRA_LDFLAGS="-static"
      elif test "''${NIX_DONT_SET_RPATH-}" != "1"; then
          EXTRA_LDFLAGS="-Wl,-rpath,''${!outputLib}/lib"
      else
          EXTRA_LDFLAGS=""
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
              declare -a prefixExtraLDFlags=()
              prefixExtraLDFlags=("-L$libc_libdir")
              nixDontSetRpathVar=NIX_DONT_SET_RPATH''${post}
              if test "''${!nixDontSetRpathVar-}" != "1"; then
                  prefixExtraLDFlags+=("-rpath" "$libc_libdir")
              fi
              extraLDFlags=("''${prefixExtraLDFlags[@]}" "''${extraLDFlags[@]}")
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

          if test -z "''${targetConfig-}"; then
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

          if test -z "''${targetConfig-}"; then
              makeFlagsArray+=(
                  "BOOT_CFLAGS=$EXTRA_FLAGS $EXTRA_LDFLAGS"
                  "BOOT_LDFLAGS=$EXTRA_FLAGS_FOR_TARGET $EXTRA_LDFLAGS_FOR_TARGET"
              )
          fi

          if test "$withoutTargetLibc" == 1; then
              # We don't want the gcc build to assume there will be a libc providing
              # limits.h in this stage
              makeFlagsArray+=(
                  'LIMITS_H_TEST=false'
              )
          else
              makeFlagsArray+=(
                  'LIMITS_H_TEST=true'
              )
          fi
      fi

      eval "$oldOpts"
    '';

    preConfigure =
      (originalAttrs.preConfigure or "")
      + ''
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

        if test -n "$crossMingw" -a -n "$withoutTargetLibc"; then
            mkdir -p ../mingw
            # --with-build-sysroot expects that:
            cp -R $libcCross/include ../mingw
            appendToVar configureFlags "--with-build-sysroot=`pwd`/.."
        fi

        # Perform the build in a different directory.
        mkdir ../build
        cd ../build
        configureScript=../$sourceRoot/configure
      '';

    postConfigure = ''
      # Avoid store paths when embedding ./configure flags into gcc.
      # Mangled arguments are still useful when reporting bugs upstream.
      sed -e "/TOPLEVEL_CONFIGURE_ARGUMENTS=/ s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" -i Makefile
    '';

    preInstall =
      ''
        mkdir -p "$out/''${targetConfig}/lib"
        mkdir -p "''${!outputLib}/''${targetConfig}/lib"
      ''
      +
        # if cross-compiling, link from $lib/lib to $lib/${targetConfig}.
        # since native-compiles have $lib/lib as a directory (not a
        # symlink), this ensures that in every case we can assume that
        # $lib/lib contains the .so files
        lib.optionalString (with stdenv; targetPlatform.config != hostPlatform.config) ''
          ln -Ts "''${!outputLib}/''${targetConfig}/lib" $lib/lib
        ''
      +
        # Make `lib64` symlinks to `lib`.
        lib.optionalString
          (!enableMultilib && stdenv.hostPlatform.is64bit && !stdenv.hostPlatform.isMips64n32)
          ''
            ln -s lib "$out/''${targetConfig}/lib64"
            ln -s lib "''${!outputLib}/''${targetConfig}/lib64"
          ''
      +
        # On mips platforms, gcc follows the IRIX naming convention:
        #
        #  $PREFIX/lib   = mips32
        #  $PREFIX/lib32 = mips64n32
        #  $PREFIX/lib64 = mips64
        #
        # Make `lib32` symlinks to `lib`.
        lib.optionalString (!enableMultilib && stdenv.targetPlatform.isMips64n32) ''
          ln -s lib "$out/''${targetConfig}/lib32"
          ln -s lib "''${!outputLib}/''${targetConfig}/lib32"
        '';

    postInstall = ''
      # Move runtime libraries to lib output.
      moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.so*" "''${!outputLib}"
      moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.la"  "''${!outputLib}"
      moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.dylib" "''${!outputLib}"
      moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.dll.a" "''${!outputLib}"
      moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.dll" "''${!outputLib}"
      moveToOutput "share/gcc-*/python" "''${!outputLib}"

      if [ -z "$enableShared" ]; then
          moveToOutput "''${targetConfig+$targetConfig/}lib/lib*.a" "''${!outputLib}"
      fi

      for i in "''${!outputLib}/''${targetConfig}"/lib/*.{la,py}; do
          substituteInPlace "$i" --replace "$out" "''${!outputLib}"
      done

      if [ -n "$enableMultilib" ]; then
          moveToOutput "''${targetConfig+$targetConfig/}lib64/lib*.so*" "''${!outputLib}"
          moveToOutput "''${targetConfig+$targetConfig/}lib64/lib*.la"  "''${!outputLib}"
          moveToOutput "''${targetConfig+$targetConfig/}lib64/lib*.dylib" "''${!outputLib}"
          moveToOutput "''${targetConfig+$targetConfig/}lib64/lib*.dll.a" "''${!outputLib}"
          moveToOutput "''${targetConfig+$targetConfig/}lib64/lib*.dll" "''${!outputLib}"

          for i in "''${!outputLib}/''${targetConfig}"/lib64/*.{la,py}; do
              substituteInPlace "$i" --replace "$out" "''${!outputLib}"
          done
      fi

      # Remove `fixincl' to prevent a retained dependency on the
      # previous gcc.
      rm -rf $out/libexec/gcc/*/*/install-tools
      rm -rf $out/lib/gcc/*/*/install-tools

      # More dependencies with the previous gcc or some libs (gccbug stores the build command line)
      rm -rf $out/bin/gccbug

      if type "install_name_tool"; then
          for i in "''${!outputLib}"/lib/*.*.dylib "''${!outputLib}"/lib/*.so.[0-9]; do
              install_name_tool -id "$i" "$i" || true
              for old_path in $(otool -L "$i" | grep "$out" | awk '{print $1}'); do
                new_path=`echo "$old_path" | sed "s,$out,''${!outputLib},"`
                install_name_tool -change "$old_path" "$new_path" "$i" || true
              done
          done
      fi

      # Get rid of some "fixed" header files
      rm -rfv $out/lib/gcc/*/*/include-fixed/{root,linux,sys/mount.h,bits/statx.h,pthread.h}

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
  }
))
