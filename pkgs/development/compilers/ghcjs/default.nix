{ stdenv, lib, fetchFromGitHub, runCommand, buildEnv, makeWrapper
, writeText

, bootPkgs, haskellPackages, haskell
, nodejs
}:

with haskell.lib;
let
  dynamicCabal2nix = dir: runCommand "dynamic-cabal2nix" {
    nativeBuildInputs = [ haskellPackages.cabal2nix ];
  } "cabal2nix ${dir} > $out";

  src = fetchFromGitHub {
    owner = "forked-upstream-packages-for-ghcjs";
    repo = "ghcjs";

    #rev = "4ebfa7cae3d96732b55a4bf8c5ab8e3aec148869";
    #sha256 = "1qrmhz2q81639brks8v17673inxw2xihaz8m4xk9k1y3n6kgw7zh";

    #rev = "c883be65b0f0441135ea1d244c342c8634b79ed6";
    #sha256 = "1spbrdhnhlr0l13a3hixbbaxicz96yw655vv6kbfnqqljssilv4z";

    rev = "ec48bbdd600d8f39dc26961b4b18c75d80c05625";
    sha256 = "0d5s96h0qx08rdg15y9zq61rs4x8s2g3d0x4bpldnabnrvilhywk";
  };

  ghcFork = fetchFromGitHub {
    owner = "forked-upstream-packages-for-ghcjs";
    repo = "ghc";
    rev = "08987969fb59453b54fdaea4e8fbf4cd1260f993";
    sha256 = "1ch7sg1j9276fxfv6nx5b6fqvv742z6npn0ziryg3l0rxa0m65y4";
  };

  stage0Pkgs = bootPkgs.override {
    overrides = self: super: {
      ghcjs = overrideCabal (self.callPackage (dynamicCabal2nix "${src}/ghcjs") {}) (drv: {
        doCheck   = false;
        doHaddock = false;
      });
      ghcjs-prim = self.callPackage ./ghcjs-prim.nix {
        src = "${src}/ghcjs-prim";
      }; # cannot autogenerate for now
      genprimopcode = addBuildTools
        (self.callPackage (dynamicCabal2nix "${ghcFork}/utils/genprimopcode") {})
        (with self; [ alex happy ]);
    };
  };

  ghc                = stage0Pkgs.ghc;
  ghcLibDir          = "${ghc}/lib/ghc-${ghc.version}";
  ghcPackageCfgDir   = "${ghcLibDir}/package.conf.d";

  ghcjs              = stage0Pkgs.ghcjs;
  ghcjsLibDir        = "$out/lib/ghcjs-${ghcjs.version}";
  ghcjsPackageCfgDir = "${ghcjsLibDir}/package.conf.d";

# Bare-bones boot process
in buildEnv {
  inherit (ghcjs) name;
  paths = [];
  postBuild = ''
    # Wrap Exectutables
    . ${makeWrapper}/nix-support/setup-hook

    for prg in ghcjs ghcjsi ghcjs-${ghcjs.version} ghcjsi-${ghcjs.version}; do
      if [[ -x "${ghcjs}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghcjs}/bin/$prg $out/bin/$prg \
          --add-flags "-B${ghcjsLibDir}"
      fi
    done

    for prg in runghcjs; do
      if [[ -x "${ghcjs}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghcjs}/bin/$prg $out/bin/$prg \
          --add-flags "-f $out/bin/ghcjs"
      fi
    done

    for prg in ghcjs-pkg ghcjs-pkg-${ghcjs.version}; do
      if [[ -x "${ghcjs}/bin/$prg" ]]; then
        rm -f $out/bin/$prg
        makeWrapper ${ghcjs}/bin/$prg $out/bin/$prg --add-flags \
          "--global-package-db=${ghcjsPackageCfgDir}"
      fi
    done

    mkdir -p ${ghcjsLibDir}
    mkdir -p ${ghcjsPackageCfgDir}

    # Install dummy RTS
    cp ${ghcPackageCfgDir}/builtin_rts.conf ${ghcjsPackageCfgDir}/
    sed -E -i ${ghcjsPackageCfgDir}/builtin_rts.conf \
      -e "s_^(library-dirs:).*_\1 ${ghcjsPackageCfgDir}/include_" \
      -e "s_^(library-dirs:).*_\1 ${ghcjsPackageCfgDir}/lib_"

    # Install dummy configuration
    cp ${ghcLibDir}/settings ${ghcjsLibDir}/
    cp ${ghcLibDir}/platformConstants ${ghcjsLibDir}/

    # Install dummy configuration
    cp -r ${ghcFork}/data/include/ ${ghcjsLibDir}

    # Install unlit
    cp ${ghcLibDir}/unlit ${ghcjsLibDir}/

    # Create empty object file for "src/Gen2/DynamicLinking.hs"
    ${ghc}/bin/ghc -c ${writeText "empty.c" ""} -o ${ghcjsLibDir}/empty.o

    # Finalize package DB
    $out/bin/ghcjs-pkg recache
    $out/bin/ghcjs-pkg check

    touch ${ghcjsLibDir}/ghcjs_boot.completed
  '';
  passthru = {
    preferLocalBuild = true;
    inherit (ghcjs) version meta;
    bootPkgs = stage0Pkgs;
    isCross = true;
    isGhcjs = true;
    inherit nodejs;
    inherit src ghcFork;
  };
}
