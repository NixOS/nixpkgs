{ stdenv, lib, fetchFromGitHub, runCommand, buildEnv, makeWrapper
, writeText, rsync

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

    # dyn keys
    rev = "10a9ecaec4cfd180b29c3e443ec04a2694d5643f";
    sha256 = "1a3k30yi9r9c4x713b2w4ka13lazz7sx79fhq6k7wmnn8dzf0xg7";

    # hard keys
    #rev = "91880ffac598320c1b5b20fbde6926a30b3abece";
    #sha256 = "1759hrp4qykns806f73bbj5iz4sy22azw0vq39d2jb14x6vgdba5";
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

  shims = fetchFromGitHub {
    owner = "ghcjs";
    repo = "shims";
    rev = "45f44f5f027ec03264b61b8049951e765cc0b23a";
    sha256 = "090pz4rzwlcrjavbbzxhf6c7rq7rzmr10g89hmhw4c65c4fyyykp";
  };

  ghc                = stage0Pkgs.ghc;
  ghcLibDir          = "${ghc}/lib/ghc-${ghc.version}";
  ghcPackageCfgDir   = "${ghcLibDir}/package.conf.d";

  ghcjs              = stage0Pkgs.ghcjs;
  ghcjsLibDir        = "$out/lib/ghcjs-${ghcjs.version}";
  ghcjsPackageCfgDir = "${ghcjsLibDir}/package.conf.d";

# Bare-bones boot process
in buildEnv {
  buildInputs = [ rsync ];
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

    # Install real configuration
    rsync -r ${src}/ghcjs/lib/etc/ ${ghcjsLibDir}/

    # Install headers
    mkdir ${ghcjsLibDir}/include/
    rsync -r ${ghcFork}/data/include/ ${ghcjsLibDir}/include/
    rsync -r ${src}/ghcjs/lib/include/ ${ghcjsLibDir}/include/

    # Install unlit
    cp ${ghcLibDir}/unlit ${ghcjsLibDir}/

    # Create empty object file for "src/Gen2/DynamicLinking.hs"
    ${ghc}/bin/ghc -c ${writeText "empty.c" ""} -o ${ghcjsLibDir}/empty.o

    # Install shims
    cp -r ${shims} ${ghcjsLibDir}/shims

    # Install documentation
    cp -r ${src}/ghcjs/doc/ ${ghcjsLibDir}/

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
