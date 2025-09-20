{
  lib,
  stdenv,
  fetchurl,
  perl,
  gcc,
  ncurses5,
  ncurses6,
  gmp,
  libiconv,
  numactl,
  libffi,
  coreutils,
  targetPackages,
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  version = "9.6.6";

  ghcBinDists = {
    # Binary distributions for the default libc (e.g. glibc)
    # nixpkgs uses for the respective system.
    defaultLibc = {
      powerpc64-linux = {
        variantSuffix = "";
        # GHC upstream doesn't release bindists tarballs for big-endian POWER anymore.
        # We're using Debian's binary package, and patching it into a usage-in-Nixpkgs state.
        src = {
          url = "http://ftp.ports.debian.org/debian-ports/pool-ppc64/main/g/ghc/ghc_9.6.6-4_ppc64.deb";
          sha256 = "722cc301b6ba70b342e5e3d9d0671440bcd749cd2f13dcccbd23c3f6a6060171";
        };
        exePathForLibraryCheck = null;
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
          {
            nixPackage = libffi;
            fileToCheckFor = null;
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

  runtimeDeps = [
    targetPackages.stdenv.cc
    targetPackages.stdenv.cc.bintools
    coreutils # for cat
  ];

in

stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "ghc-binary${binDistUsed.variantSuffix}";

  src = fetchurl binDistUsed.src;

  nativeBuildInputs = [ perl ];

  sourceRoot = "${finalAttrs.pname}-${finalAttrs.version}";

  # Custom unpack phase to handle .deb files
  unpackPhase = ''
    runHook preUnpack

    ar x $src
    tar xf data.tar.xz
    mkdir -p ${finalAttrs.sourceRoot}
    mv -t ${finalAttrs.sourceRoot}/ usr var

    runHook postUnpack
  '';

  postUnpack =
    # Verify our assumptions of which `libtinfo.so` (ncurses) version is used,
    # so that we know when ghc bindists upgrade that and we need to update the
    # version used in `archSpecificLibraries`.
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

    # We have to patch the GMP paths for the ghc-bignum package, for hadrian by
    # modifying the package-db directly
    + ''
      find . -name 'ghc-bignum*.conf' \
          -exec sed -e '/^[a-z-]*library-dirs/a \    ${lib.getLib gmpUsed}/lib' -i {} \;
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

  # GHC has a patched config.sub and bindists' platforms should always work
  dontUpdateAutotoolsGnuConfigScripts = true;

  # Not a bindist, nothing to configure
  dontConfigure = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # Install prebuilt GHC files
  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -t $out/ -a usr/*
    rm -f $out/lib/ghc/lib/package.conf.d
    find var -name "package.conf.d" -type d -exec cp -a {} $out/lib/ghc/lib/ \;

    runHook postInstall
  '';

  postInstall =
    # Patch scripts to include runtime dependencies in $PATH.
    ''
      for i in "$out/bin/"*; do
        test ! -h "$i" || continue
        isScript "$i" || continue
        sed -i -e '2i export PATH="${lib.makeBinPath runtimeDeps}:$PATH"' "$i"
      done
    ''

    # Patch /usr paths
    + ''
      for i in "$out/bin/"*; do
        test ! -h "$i" || continue
        isScript "$i" || continue
        substituteInPlace "$i" \
          --replace-fail '="/usr' '="/${placeholder "out"}'
      done
      find "$out/lib/ghc/lib/package.conf.d" -type f -name '*.conf' \
        -exec sed -i "s|/usr/|$out/|g" {} +
    ''

    # Patch ghc settings
    # TODO:
    # - C++ compiler link flags don't already exist, would need to insert them
    + ''
      substituteInPlace $out/lib/ghc/lib/settings \
        --replace-fail powerpc64-linux-gnu-gcc gcc \
        --replace-fail powerpc64-linux-gnu-g++ g++ \
        --replace-fail powerpc64-linux-gnu-ld ld \
        --replace-fail powerpc64-linux-gnu-ar ar \
        --replace-fail powerpc64-linux-gnu-ranlib ranlib \
        --replace-fail llc-18 llc \
        --replace-fail opt-18 opt \
        --replace-fail '"Use LibFFI", "YES"' '"Use LibFFI", "NO"' \
        --replace-fail '"C compiler link flags", ""' '"C compiler link flags", "-L${libffi.out}/lib -L${numactl.out}/lib"' \
        --replace-warn '"C++ compiler link flags", ""' '"C++ compiler link flags", "-L${libffi.out}/lib -L${numactl.out}/lib"'
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
    lib.optionalString (stdenv.hostPlatform.isLinux && !(binDistUsed.isStatic or false))
      # Keep rpath as small as possible for patchelf#244.  All Elfs
      # are 2 directories deep from $out/lib, so pooling symlinks there makes
      # a short rpath.
      ''
        (cd $out/lib; ln -s ${ncurses6.out}/lib/libtinfo.so.6)
        (cd $out/lib; ln -s ${lib.getLib gmpUsed}/lib/libgmp.so.10)
        (cd $out/lib; ln -s ${numactl.out}/lib/libnuma.so.1)
        (cd $out/lib; ln -s ${libffi.out}/lib/libffi.so.8)
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
    # Recache package db which needs to happen for Hadrian bindists
    # where we modify the package db before installing
    + ''
      package_db=("$out"/lib/ghc*/lib/package.conf.d)
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
    teams = [ lib.teams.haskell ];
  };
})
