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

  # GHC upstream doesn't release bindist tarballs for some platforms.
  # We're using Debian's binary package, and patching it into a usable-in-Nixpkgs state.
  ghcDebs = {
    powerpc64-linux = {
      src = {
        urls = [
          "http://ftp.ports.debian.org/debian-ports/pool-ppc64/main/g/ghc/ghc_9.6.6-4_ppc64.deb"
          "https://snapshot.debian.org/archive/debian-ports/20250917T193713Z/pool-ppc64/main/g/ghc/ghc_9.6.6-4_ppc64.deb"
        ];
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

  debUsed =
    ghcDebs.${stdenv.hostPlatform.system}
      or (throw "cannot bootstrap GHC on this platform ('${stdenv.hostPlatform.system}') from Debian debs");

  gmpUsed =
    (builtins.head (
      builtins.filter (drv: lib.hasPrefix "gmp" (drv.nixPackage.name or "")) debUsed.archSpecificLibraries
    )).nixPackage;

  runtimeDeps = [
    targetPackages.stdenv.cc
    targetPackages.stdenv.cc.bintools
    coreutils # for cat
  ];

  extraLibraryMapping = {
    gmp = gmpUsed;
    numa = numactl;
    ffi = libffi;
  };

in

stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "ghc-debian-binary";

  src = fetchurl debUsed.src;

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
    # so that we know when ghc debs upgrade that and we need to update the
    # version used in `archSpecificLibraries`.
    lib.optionalString (debUsed.exePathForLibraryCheck != null) (
      lib.concatStringsSep "\n" [
        ''
          shopt -u nullglob
          echo "Checking that ghc binary exists in deb at ${debUsed.exePathForLibraryCheck}"
          if ! test -e ${debUsed.exePathForLibraryCheck}; then
            echo >&2 "GHC binary ${debUsed.exePathForLibraryCheck} could not be found in the deb unpack directory for arch ${stdenv.hostPlatform.system}, please check that ghcDebs correctly reflect the deb dependencies!"; exit 1;
          fi
        ''
        (lib.concatMapStringsSep "\n" (
          { fileToCheckFor, nixPackage }:
          lib.optionalString (fileToCheckFor != null) ''
            echo "Checking deb for ${fileToCheckFor} to ensure that is still used"
            if ! readelf -d ${debUsed.exePathForLibraryCheck} | grep "${fileToCheckFor}"; then
              echo >&2 "File ${fileToCheckFor} could not be found in ${debUsed.exePathForLibraryCheck} for arch ${stdenv.hostPlatform.system}, please check that ghcDebs correctly reflect the deb dependencies!"; exit 1;
            fi

            echo "Checking that the nix package ${nixPackage} contains ${fileToCheckFor}"
            if ! test -e "${lib.getLib nixPackage}/lib/${fileToCheckFor}"; then
              echo >&2 "Nix package ${nixPackage} did not contain ${fileToCheckFor} for arch ${stdenv.hostPlatform.system}, please check that ghcDebs correctly reflect the deb dependencies!"; exit 1;
            fi
          ''
        ) debUsed.archSpecificLibraries)
      ]
    )

    # Linking to non-compiler libraries requires GHC to know about our non-FHS paths for those libraries
    + (lib.strings.concatMapAttrsStringSep "\n" (libName: libPackage: ''
      for packageDbDir in $(find . -name package.conf.d); do
        for packageDb in $(grep -l 'extra-libraries:.*${libName}' "$packageDbDir"/*.conf); do
          echo "Patching include & library path for ${libName} into package DB: $packageDb"
          sed -i "$packageDb" \
            -e '/^[a-z-]*include-dirs/a \    ${lib.getDev libPackage}/include' \
            -e '/^[a-z-]*library-dirs/a \    ${lib.getLib libPackage}/lib'
        done
      done
    '') extraLibraryMapping)

    +
      # Rename needed libraries and binaries, fix interpreter
      lib.optionalString stdenv.hostPlatform.isLinux ''
        find . -type f -executable -exec patchelf \
            --interpreter ${stdenv.cc.bintools.dynamicLinker} {} \;
      '';

  # Not a bindist, nothing to configure
  dontConfigure = true;

  # Not a bindist, it's already built
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
          --replace-fail '="/usr' '="${placeholder "out"}'
      done
      find "$out/lib/ghc/lib/package.conf.d" -type f -name '*.conf' \
        -exec sed -i "s|/usr/|$out/|g" {} +
    ''

    # Patch ghc settings
    + ''
      substituteInPlace $out/lib/ghc/lib/settings \
        --replace-fail powerpc64-linux-gnu-gcc gcc \
        --replace-fail powerpc64-linux-gnu-g++ g++ \
        --replace-fail powerpc64-linux-gnu-ld ld \
        --replace-fail powerpc64-linux-gnu-ar ar \
        --replace-fail powerpc64-linux-gnu-ranlib ranlib \
        --replace-fail llc-18 llc \
        --replace-fail opt-18 opt
    '';

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postFixup =
    lib.optionalString (stdenv.hostPlatform.isLinux && !(debUsed.isStatic or false))
      # Keep rpath as small as possible, running autoPatchelf makes everything segfault (maybe similar to patchelf#244).
      # All Elfs are 2 directories deep from $out/lib, so pooling symlinks there makes a short rpath.
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
    # Recache package db which needs to happen because
    # we modify the package db
    + ''
      "$out/bin/ghc-pkg" --package-db=$out/lib/ghc/lib/package.conf.d recache
    '';

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
    # here. In the case of debs we just make sure that the attribute exists,
    # as it is used for checking if a GHC derivation has been built with hadrian.
    hadrian = null;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "Glasgow Haskell Compiler";
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames ghcDebs;
    maintainers = [ lib.maintainers.OPNA2608 ];
    teams = [ lib.teams.haskell ];
  };
})
