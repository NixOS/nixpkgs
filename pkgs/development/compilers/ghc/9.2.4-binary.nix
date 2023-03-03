{ lib, stdenv
, fetchurl, perl, gcc
, ncurses5
, ncurses6, gmp, libiconv, numactl, libffi
, llvmPackages
, coreutils
, targetPackages

  # minimal = true; will remove files that aren't strictly necessary for
  # regular builds and GHC bootstrapping.
  # This is "useful" for staying within hydra's output limits for at least the
  # aarch64-linux architecture.
, minimal ? false
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  downloadsUrl = "https://downloads.haskell.org/ghc";

  # Copy sha256 from https://downloads.haskell.org/~ghc/9.2.4/SHA256SUMS
  version = "9.2.4";

  # Information about available bindists that we use in the build.
  #
  # # Bindist library checking
  #
  # The field `archSpecificLibraries` also provides a way for us get notified
  # early when the upstream bindist changes its dependencies (e.g. because a
  # newer Debian version is used that uses a new `ncurses` version).
  #
  # Usage:
  #
  # * You can find the `fileToCheckFor` of libraries by running `readelf -d`
  #   on the compiler binary (`exePathForLibraryCheck`).
  # * To skip library checking for an architecture,
  #   set `exePathForLibraryCheck = null`.
  # * To skip file checking for a specific arch specfic library,
  #   set `fileToCheckFor = null`.
  ghcBinDists = {
    # Binary distributions for the default libc (e.g. glibc, or libSystem on Darwin)
    # nixpkgs uses for the respective system.
    defaultLibc = {
      i686-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-i386-deb9-linux.tar.xz";
          sha256 = "5dc1eb9c65f01b1e5c5693af72af07a4e9e75c6920e620fd598daeefa804487a";
        };
        exePathForLibraryCheck = "ghc/stage2/build/tmp/ghc-stage2";
        archSpecificLibraries = [
          { nixPackage = gmp; fileToCheckFor = null; }
          # The i686-linux bindist provided by GHC HQ is currently built on Debian 9,
          # which link it against `libtinfo.so.5` (ncurses 5).
          # Other bindists are linked `libtinfo.so.6` (ncurses 6).
          { nixPackage = ncurses5; fileToCheckFor = "libtinfo.so.5"; }
        ];
      };
      x86_64-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-deb10-linux.tar.xz";
          sha256 = "a77a91a39d9b0167124b7e97648b2b52973ae0978cb259e0d44f0752a75037cb";
        };
        exePathForLibraryCheck = "ghc/stage2/build/tmp/ghc-stage2";
        archSpecificLibraries = [
          { nixPackage = gmp; fileToCheckFor = null; }
          { nixPackage = ncurses6; fileToCheckFor = "libtinfo.so.6"; }
        ];
      };
      aarch64-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-deb10-linux.tar.xz";
          sha256 = "fc7dbc6bae36ea5ac30b7e9a263b7e5be3b45b0eb3e893ad0bc2c950a61f14ec";
        };
        exePathForLibraryCheck = "ghc/stage2/build/tmp/ghc-stage2";
        archSpecificLibraries = [
          { nixPackage = gmp; fileToCheckFor = null; }
          { nixPackage = ncurses6; fileToCheckFor = "libtinfo.so.6"; }
          { nixPackage = numactl; fileToCheckFor = null; }
        ];
      };
      x86_64-darwin = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
          sha256 = "f2e8366fd3754dd9388510792aba2d2abecb1c2f7f1e5555f6065c3c5e2ffec4";
        };
        exePathForLibraryCheck = null; # we don't have a library check for darwin yet
        archSpecificLibraries = [
          { nixPackage = gmp; fileToCheckFor = null; }
          { nixPackage = ncurses6; fileToCheckFor = null; }
          { nixPackage = libiconv; fileToCheckFor = null; }
        ];
        isHadrian = true;
      };
      aarch64-darwin = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-apple-darwin.tar.xz";
          sha256 = "8cf8408544a1a43adf1bbbb0dd6b074efadffc68bfa1a792947c52e825171224";
        };
        exePathForLibraryCheck = null; # we don't have a library check for darwin yet
        archSpecificLibraries = [
          { nixPackage = gmp; fileToCheckFor = null; }
          { nixPackage = ncurses6; fileToCheckFor = null; }
          { nixPackage = libiconv; fileToCheckFor = null; }
        ];
        isHadrian = true;
      };
    };
    # Binary distributions for the musl libc for the respective system.
    musl = {
      x86_64-linux = {
        variantSuffix = "-musl";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-alpine3.12-linux-gmp.tar.xz";
          sha256 = "026348947d30a156b84de5d6afeaa48fdcb2795b47954cd8341db00d3263a481";
        };
        isStatic = true;
        isHadrian = true;
        # We can't check the RPATH for statically linked executable
        exePathForLibraryCheck = null;
        archSpecificLibraries = [
          { nixPackage = gmp.override { withStatic = true; }; fileToCheckFor = null; }
        ];
      };
    };
  };

  distSetName = if stdenv.hostPlatform.isMusl then "musl" else "defaultLibc";

  binDistUsed = ghcBinDists.${distSetName}.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform ('${stdenv.hostPlatform.system}' with libc '${distSetName}')");

  gmpUsed = (builtins.head (
    builtins.filter (
      drv: lib.hasPrefix "gmp" (drv.nixPackage.name or "")
    ) binDistUsed.archSpecificLibraries
  )).nixPackage;

  # GHC has other native backends (like PowerPC), but here only the ones
  # we ship bindists for matter.
  useLLVM = !(stdenv.targetPlatform.isx86
    || (stdenv.targetPlatform.isAarch64 && stdenv.targetPlatform.isDarwin));

  libPath =
    lib.makeLibraryPath (
      # Add arch-specific libraries.
      map ({ nixPackage, ... }: nixPackage) binDistUsed.archSpecificLibraries
    );

  libEnvVar = lib.optionalString stdenv.hostPlatform.isDarwin "DY"
    + "LD_LIBRARY_PATH";

  runtimeDeps = [
    targetPackages.stdenv.cc
    targetPackages.stdenv.cc.bintools
    coreutils # for cat
  ]
  ++ lib.optionals useLLVM [
    (lib.getBin llvmPackages.llvm)
  ]
  # On darwin, we need unwrapped bintools as well (for otool)
  ++ lib.optionals (stdenv.targetPlatform.linker == "cctools") [
    targetPackages.stdenv.cc.bintools.bintools
  ];

in

stdenv.mkDerivation rec {
  inherit version;
  pname = "ghc-binary${binDistUsed.variantSuffix}";

  src = fetchurl binDistUsed.src;

  nativeBuildInputs = [ perl ];

  # Set LD_LIBRARY_PATH or equivalent so that the programs running as part
  # of the bindist installer can find the libraries they expect.
  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location.
  ${libEnvVar} = libPath;

  postUnpack =
    # Verify our assumptions of which `libtinfo.so` (ncurses) version is used,
    # so that we know when ghc bindists upgrade that and we need to update the
    # version used in `libPath`.
    lib.optionalString
      (binDistUsed.exePathForLibraryCheck != null)
      # Note the `*` glob because some GHCs have a suffix when unpacked, e.g.
      # the musl bindist has dir `ghc-VERSION-x86_64-unknown-linux/`.
      # As a result, don't shell-quote this glob when splicing the string.
      (let buildExeGlob = ''ghc-${version}*/"${binDistUsed.exePathForLibraryCheck}"''; in
        lib.concatStringsSep "\n" [
          (''
            echo "Checking that ghc binary exists in bindist at ${buildExeGlob}"
            if ! test -e ${buildExeGlob}; then
              echo >&2 "GHC binary ${binDistUsed.exePathForLibraryCheck} could not be found in the bindist build directory (at ${buildExeGlob}) for arch ${stdenv.hostPlatform.system}, please check that ghcBinDists correctly reflect the bindist dependencies!"; exit 1;
            fi
          '')
          (lib.concatMapStringsSep
            "\n"
            ({ fileToCheckFor, nixPackage }:
              lib.optionalString (fileToCheckFor != null) ''
                echo "Checking bindist for ${fileToCheckFor} to ensure that is still used"
                if ! readelf -d ${buildExeGlob} | grep "${fileToCheckFor}"; then
                  echo >&2 "File ${fileToCheckFor} could not be found in ${binDistUsed.exePathForLibraryCheck} for arch ${stdenv.hostPlatform.system}, please check that ghcBinDists correctly reflect the bindist dependencies!"; exit 1;
                fi

                echo "Checking that the nix package ${nixPackage} contains ${fileToCheckFor}"
                if ! test -e "${lib.getLib nixPackage}/lib/${fileToCheckFor}"; then
                  echo >&2 "Nix package ${nixPackage} did not contain ${fileToCheckFor} for arch ${stdenv.hostPlatform.system}, please check that ghcBinDists correctly reflect the bindist dependencies!"; exit 1;
                fi
              ''
            )
            binDistUsed.archSpecificLibraries
          )
        ])
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    + lib.optionalString stdenv.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find . -type f -executable); do
        isScript $exe && continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
      done
    '' +

    # Some scripts used during the build need to have their shebangs patched
    ''
      patchShebangs ghc-${version}/utils/
      patchShebangs ghc-${version}/configure
    '' +
    # We have to patch the GMP paths for the integer-gmp package.
    ''
      find . -name ghc-bignum.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${lib.getLib gmpUsed}/lib@" {} \;

      # we need to modify the package db directly for hadrian bindists
      find . -name 'ghc-bignum*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib gmpUsed}/lib' -i {} \;
    '' + lib.optionalString stdenv.isDarwin ''
      # we need to modify the package db directly for hadrian bindists
      # (all darwin bindists are hadrian-based for 9.2.2)
      find . -name 'base*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib libiconv}/lib' -i {} \;

      # To link RTS in the end we also need libffi now
      find . -name 'rts*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib libffi}/lib' \
                    -e 's@/Library/Developer/.*/usr/include/ffi@${lib.getDev libffi}/include@' \
                    -i {} \;
    '' +
    # aarch64 does HAVE_NUMA so -lnuma requires it in library-dirs in rts/package.conf.in
    # FFI_LIB_DIR is a good indication of places it must be needed.
    lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
      find . -name package.conf.in \
          -exec sed -i "s@FFI_LIB_DIR@FFI_LIB_DIR ${numactl.out}/lib@g" {} \;
    '' +
    # Rename needed libraries and binaries, fix interpreter
    lib.optionalString stdenv.isLinux ''
      find . -type f -executable -exec patchelf \
          --interpreter ${stdenv.cc.bintools.dynamicLinker} {} \;
    '';

  # fix for `configure: error: Your linker is affected by binutils #16177`
  preConfigure = lib.optionalString
    stdenv.targetPlatform.isAarch32
    "LD=ld.gold";

  configurePlatforms = [ ];
  configureFlags = [
    "--with-gmp-includes=${lib.getDev gmpUsed}/include"
    # Note `--with-gmp-libraries` does nothing for GHC bindists:
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/6124
  ] ++ lib.optional stdenv.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"
    # From: https://github.com/NixOS/nixpkgs/pull/43369/commits
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-ld-override";

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # Patch scripts to include runtime dependencies in $PATH.
  postInstall = ''
    for i in "$out/bin/"*; do
      test ! -h "$i" || continue
      isScript "$i" || continue
      sed -i -e '2i export PATH="${lib.makeBinPath runtimeDeps}:$PATH"' "$i"
    done
  '';

  # Apparently necessary for the ghc Alpine (musl) bindist:
  # When we strip, and then run the
  #     patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
  # below, running ghc (e.g. during `installCheckPhase)` gives some apparently
  # corrupted rpath or whatever makes the loader work on nonsensical strings:
  #     running install tests
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: : symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: ir6zf6c9f86pfx8sr30n2vjy-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/../lib/x86_64-linux-ghc-8.10.5/libHSexceptions-0.10.4-ghc8.10.5.so: symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: y/lib/ghc-8.10.5/bin/../lib/x86_64-linux-ghc-8.10.5/libHStemplate-haskell-2.16.0.0-ghc8.10.5.so: symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: 8.10.5/libHStemplate-haskell-2.16.0.0-ghc8.10.5.so: symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: �: symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: �?: symbol not found
  #     Error relocating /nix/store/...-ghc-8.10.2-binary/lib/ghc-8.10.5/bin/ghc: 64-linux-ghc-8.10.5/libHSexceptions-0.10.4-ghc8.10.5.so: symbol not found
  # This is extremely bogus and should be investigated.
  dontStrip = if stdenv.hostPlatform.isMusl then true else false; # `if` for explicitness

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postFixup = lib.optionalString (stdenv.isLinux && !(binDistUsed.isStatic or false))
    (if stdenv.hostPlatform.isAarch64 then
      # Keep rpath as small as possible on aarch64 for patchelf#244.  All Elfs
      # are 2 directories deep from $out/lib, so pooling symlinks there makes
      # a short rpath.
      ''
      (cd $out/lib; ln -s ${ncurses6.out}/lib/libtinfo.so.6)
      (cd $out/lib; ln -s ${lib.getLib gmpUsed}/lib/libgmp.so.10)
      (cd $out/lib; ln -s ${numactl.out}/lib/libnuma.so.1)
      for p in $(find "$out/lib" -type f -name "*\.so*"); do
        (cd $out/lib; ln -s $p)
      done

      for p in $(find "$out/lib" -type f -executable); do
        if isELF "$p"; then
          echo "Patchelfing $p"
          patchelf --set-rpath "\$ORIGIN:\$ORIGIN/../.." $p
        fi
      done
      ''
    else
      ''
      for p in $(find "$out" -type f -executable); do
        if isELF "$p"; then
          echo "Patchelfing $p"
          patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
        fi
      done
    '') + lib.optionalString stdenv.isDarwin ''
    # not enough room in the object files for the full path to libiconv :(
    for exe in $(find "$out" -type f -executable); do
      isScript $exe && continue
      ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
      install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
    done

    for file in $(find "$out" -name setup-config); do
      substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
    done
  '' +
  lib.optionalString minimal ''
    # Remove profiling files
    find $out -type f -name '*.p_o' -delete
    find $out -type f -name '*.p_hi' -delete
    find $out -type f -name '*_p.a' -delete
    # `-f` because e.g. musl bindist does not have this file.
    rm -f $out/lib/ghc-*/bin/ghc-iserv-prof
    # Hydra will redistribute this derivation, so we have to keep the docs for
    # legal reasons (retaining the legal notices etc)
    # As a last resort we could unpack the docs separately and symlink them in.
    # They're in $out/share/{doc,man}.
  ''
  # Recache package db which needs to happen for Hadrian bindists
  # where we modify the package db before installing
  + ''
    "$out/bin/ghc-pkg" --package-db="$out/lib/"ghc-*/package.conf.d recache
  '';

  # In nixpkgs, musl based builds currently enable `pie` hardening by default
  # (see `defaultHardeningFlags` in `make-derivation.nix`).
  # But GHC cannot currently produce outputs that are ready for `-pie` linking.
  # Thus, disable `pie` hardening, otherwise `recompile with -fPIE` errors appear.
  # See:
  # * https://github.com/NixOS/nixpkgs/issues/129247
  # * https://gitlab.haskell.org/ghc/ghc/-/issues/19580
  hardeningDisable = lib.optional stdenv.targetPlatform.isMusl "pie";

  doInstallCheck = true;
  installCheckPhase = ''
    # Sanity check, can ghc create executables?
    cd $TMP
    mkdir test-ghc; cd test-ghc
    cat > main.hs << EOF
      {-# LANGUAGE TemplateHaskell #-}
      module Main where
      main = putStrLn \$([|"yes"|])
    EOF
    env -i $out/bin/ghc --make main.hs || exit 1
    echo compilation ok
    [ $(./main) == "yes" ]
  '';

  passthru = {
    targetPrefix = "";
    enableShared = true;

    inherit llvmPackages;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";
  } // lib.optionalAttrs (binDistUsed.isHadrian or false) {
    # Normal GHC derivations expose the hadrian derivation used to build them
    # here. In the case of bindists we just make sure that the attribute exists,
    # as it is used for checking if a GHC derivation has been built with hadrian.
    # The isHadrian mechanism will become obsolete with GHCs that use hadrian
    # exclusively, i.e. 9.6 (and 9.4?).
    hadrian = null;
  };

  meta = rec {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    license = lib.licenses.bsd3;
    # HACK: since we can't encode the libc / abi in platforms, we need
    # to make the platform list dependent on the evaluation platform
    # in order to avoid eval errors with musl which supports less
    # platforms than the default libcs (i. e. glibc / libSystem).
    # This is done for the benefit of Hydra, so `packagePlatforms`
    # won't return any platforms that would cause an evaluation
    # failure for `pkgsMusl.haskell.compiler.ghc922Binary`, as
    # long as the evaluator runs on a platform that supports
    # `pkgsMusl`.
    platforms = builtins.attrNames ghcBinDists.${distSetName};
    hydraPlatforms = builtins.filter (p: minimal || p != "aarch64-linux") platforms;
    maintainers = lib.teams.haskell.members;
  };
}
