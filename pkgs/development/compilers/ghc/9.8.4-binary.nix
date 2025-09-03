{
  lib,
  stdenv,
  fetchurl,
  perl,
  gcc,
  ncurses6,
  gmp,
  libiconv,
  numactl,
  libffi,
  coreutils,
  targetPackages,

  # minimal = true; will remove files that aren't strictly necessary for
  # regular builds and GHC bootstrapping.
  # This is "useful" for staying within hydra's output limits for at least the
  # aarch64-linux architecture.
  minimal ? false,
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  downloadsUrl = "https://downloads.haskell.org/ghc";

  # Copy sha256 from https://downloads.haskell.org/~ghc/9.8.4/SHA256SUMS
  version = "9.8.4";

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
  # * To skip file checking for a specific arch specific library,
  #   set `fileToCheckFor = null`.
  ghcBinDists = {
    # Binary distributions for the default libc (e.g. glibc, or libSystem on Darwin)
    # nixpkgs uses for the respective system.
    defaultLibc = {
      i686-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-i386-deb10-linux.tar.xz";
          sha256 = "e5efce16c654d5e702986258a87dd9531e1722b8051823c8ce1150ce3c5899ae";
        };
        exePathForLibraryCheck = "bin/ghc";
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = "libtinfo.so.6";
          }
        ];
      };
      x86_64-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-deb11-linux.tar.xz";
          sha256 = "af151db8682b8c763f5a44f960f65453d794c95b60f151abc82dbdefcbe6f8ad";
        };
        exePathForLibraryCheck = "bin/ghc";
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = "libtinfo.so.6";
          }
        ];
      };
      aarch64-linux = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-deb11-linux.tar.xz";
          sha256 = "310204daf2df6ad16087be94b3498ca414a0953b29e94e8ec8eb4a5c9bf603d3";
        };
        exePathForLibraryCheck = "bin/ghc";
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = "libtinfo.so.6";
          }
          {
            nixPackage = numactl;
            fileToCheckFor = null;
          }
        ];
      };
      x86_64-darwin = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
          sha256 = "de7baacfb1513ab0e4ccf8911045cceee84bc8a4e39b89bd975ed3135e5f7d96";
        };
        exePathForLibraryCheck = null; # we don't have a library check for darwin yet
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = null;
          }
          {
            nixPackage = libiconv;
            fileToCheckFor = null;
          }
        ];
      };
      aarch64-darwin = {
        variantSuffix = "";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-apple-darwin.tar.xz";
          sha256 = "e2f12a922754fd28511512875bf6d9eb3e0cce7fc963a7266f6e1661aeabd7ed";
        };
        exePathForLibraryCheck = null; # we don't have a library check for darwin yet
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = null;
          }
          {
            nixPackage = libiconv;
            fileToCheckFor = null;
          }
        ];
      };
    };
    # Binary distributions for the musl libc for the respective system.
    musl = {
      aarch64-linux = {
        variantSuffix = "-musl";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-alpine3_18-linux.tar.xz";
          sha256 = "b5c86a0cda0bd62d5eeeb52b1937c3bd00c70cd67dd74226ce787d5c429a4e62";
        };
        exePathForLibraryCheck = "bin/ghc";
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = "libncursesw.so.6";
          }
        ];
      };
      x86_64-linux = {
        variantSuffix = "-musl";
        src = {
          url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-alpine3_12-linux.tar.xz";
          sha256 = "e34bb16e8387509adc96a3d98b4a444bab425d12864c38a3629f2860b4bec2e7";
        };
        exePathForLibraryCheck = "bin/ghc";
        archSpecificLibraries = [
          {
            nixPackage = gmp;
            fileToCheckFor = null;
          }
          {
            nixPackage = ncurses6;
            fileToCheckFor = "libncursesw.so.6";
          }
        ];
      };
    };
  };

  distSetName = if stdenv.hostPlatform.isMusl then "musl" else "defaultLibc";

  binDistUsed =
    ghcBinDists.${distSetName}.${stdenv.hostPlatform.system}
      or (throw "cannot bootstrap GHC on this platform ('${stdenv.hostPlatform.system}' with libc '${distSetName}')");

  gmpUsed =
    (builtins.head (
      builtins.filter (
        drv: lib.hasPrefix "gmp" (drv.nixPackage.name or "")
      ) binDistUsed.archSpecificLibraries
    )).nixPackage;

  libPath = lib.makeLibraryPath (
    # Add arch-specific libraries.
    map ({ nixPackage, ... }: nixPackage) binDistUsed.archSpecificLibraries
  );

  libEnvVar = lib.optionalString stdenv.hostPlatform.isDarwin "DY" + "LD_LIBRARY_PATH";

  runtimeDeps = [
    targetPackages.stdenv.cc
    targetPackages.stdenv.cc.bintools
    coreutils # for cat
  ]
  # On darwin, we need unwrapped bintools as well (for otool)
  ++ lib.optionals (stdenv.targetPlatform.linker == "cctools") [
    targetPackages.stdenv.cc.bintools.bintools
  ];

in

assert import ./common-have-ncg.nix { inherit lib stdenv version; };

stdenv.mkDerivation {
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
    lib.optionalString (binDistUsed.exePathForLibraryCheck != null)
      # Note the `*` glob because some GHCs have a suffix when unpacked, e.g.
      # the musl bindist has dir `ghc-VERSION-x86_64-unknown-linux/`.
      # As a result, don't shell-quote this glob when splicing the string.
      (
        let
          buildExeGlob = ''ghc-${version}*/"${binDistUsed.exePathForLibraryCheck}"'';
        in
        lib.concatStringsSep "\n" [
          (''
            shopt -u nullglob
            echo "Checking that ghc binary exists in bindist at ${buildExeGlob}"
            if ! test -e ${buildExeGlob}; then
              echo >&2 "GHC binary ${binDistUsed.exePathForLibraryCheck} could not be found in the bindist build directory (at ${buildExeGlob}) for arch ${stdenv.hostPlatform.system}, please check that ghcBinDists correctly reflect the bindist dependencies!"; exit 1;
            fi
          '')
          (lib.concatMapStringsSep "\n" (
            { fileToCheckFor, nixPackage }:
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
          ) binDistUsed.archSpecificLibraries)
        ]
      )
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find . -type f -executable); do
        isMachO $exe || continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib $exe
      done
    ''

    # We have to patch the GMP paths for the ghc-bignum package, for hadrian by
    # modifying the package-db directly
    + ''
      find . -name 'ghc-bignum*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib gmpUsed}/lib' -i {} \;
    ''
    # Similar for iconv and libffi on darwin
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      find . -name 'base*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib libiconv}/lib' -i {} \;

      # To link RTS in the end we also need libffi now
      find . -name 'rts*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib libffi}/lib' \
                    -e 's@/Library/Developer/.*/usr/include/ffi@${lib.getDev libffi}/include@' \
                    -i {} \;
    ''
    +
      # Some platforms do HAVE_NUMA so -lnuma requires it in library-dirs in rts/package.conf.in
      # FFI_LIB_DIR is a good indication of places it must be needed.
      lib.optionalString
        (
          lib.meta.availableOn stdenv.hostPlatform numactl
          && builtins.any ({ nixPackage, ... }: nixPackage == numactl) binDistUsed.archSpecificLibraries
        )
        ''
          find . -name package.conf.in \
              -exec sed -i "s@FFI_LIB_DIR@FFI_LIB_DIR ${numactl.out}/lib@g" {} \;
        ''
    +
      # Rename needed libraries and binaries, fix interpreter
      lib.optionalString stdenv.hostPlatform.isLinux ''
        find . -type f -executable -exec patchelf \
            --interpreter ${stdenv.cc.bintools.dynamicLinker} {} \;
      '';

  # fix for `configure: error: Your linker is affected by binutils #16177`
  preConfigure = lib.optionalString stdenv.targetPlatform.isAarch32 "LD=ld.gold";

  # GHC has a patched config.sub and bindists' platforms should always work
  dontUpdateAutotoolsGnuConfigScripts = true;

  configurePlatforms = [ ];
  configureFlags =
    lib.optional stdenv.hostPlatform.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"
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
  ''
  + lib.optionalString stdenv.targetPlatform.isDarwin ''
    # Work around building with binary GHC on Darwin due to GHC’s use of `ar -L` when it
    # detects `llvm-ar` even though the resulting archives are not supported by ld64.
    # https://gitlab.haskell.org/ghc/ghc/-/issues/23188
    # https://github.com/haskell/cabal/issues/8882
    sed -i -e 's/,("ar supports -L", "YES")/,("ar supports -L", "NO")/' "$out/lib/ghc-${version}/lib/settings"
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
  postFixup =
    lib.optionalString (stdenv.hostPlatform.isLinux && !(binDistUsed.isStatic or false)) (
      if stdenv.hostPlatform.isAarch64 then
        # Keep rpath as small as possible on aarch64 for patchelf#244.  All Elfs
        # are 2 directories deep from $out/lib, so pooling symlinks there makes
        # a short rpath.
        ''
          (cd $out/lib; ln -s ${lib.getLib gmpUsed}/lib/libgmp.so.10)
        ''
        + (
          if stdenv.hostPlatform.isMusl then
            ''
              (cd $out/lib; ln -s ${ncurses6.out}/lib/libncursesw.so.6)
            ''
          else
            ''
              (cd $out/lib; ln -s ${ncurses6.out}/lib/libtinfo.so.6)
            ''
        )
        + ''
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
        ''
    )
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find "$out" -type f -executable); do
        isMachO $exe || continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib $exe
      done

      for file in $(find "$out" -name setup-config); do
        substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
      done
    ''
    # Recache package db which needs to happen for Hadrian bindists
    # where we modify the package db before installing
    + ''
      package_db=("$out"/lib/ghc-*/lib/package.conf.d)
      "$out/bin/ghc-pkg" --package-db="$package_db" recache
    '';

  # GHC cannot currently produce outputs that are ready for `-pie` linking.
  # Thus, disable `pie` hardening, otherwise `recompile with -fPIE` errors appear.
  # See:
  # * https://github.com/NixOS/nixpkgs/issues/129247
  # * https://gitlab.haskell.org/ghc/ghc/-/issues/19580
  hardeningDisable = [ "pie" ];

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

    llvmPackages = null;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";

    # Normal GHC derivations expose the hadrian derivation used to build them
    # here. In the case of bindists we just make sure that the attribute exists,
    # as it is used for checking if a GHC derivation has been built with hadrian.
    hadrian = null;
  };

  meta = rec {
    homepage = "http://haskell.org/ghc";
    description = "Glasgow Haskell Compiler";
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
    maintainers = lib.teams.haskell.members;
  };
}
