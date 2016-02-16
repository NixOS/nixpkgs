{ stdenv, lib, fetchFromGitHub, runCommand, buildEnv, makeWrapper
, writeText

, bootPkgs, haskellPackages, haskell
, nodejs
}:

with haskell.lib;
rec {
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

  stage1Pkgs = bootPkgs.override {
    ghc = let
      ghc                = stage0Pkgs.ghc;
      ghcLibDir          = "${ghc}/lib/ghc-${ghc.version}";
      ghcPackageCfgDir   = "${ghcLibDir}/package.conf.d";

      ghcjs              = stage0Pkgs.ghcjs;
      ghcjsLibDir        = "$out/lib/ghcjs-${ghcjs.version}";
      ghcjsPackageCfgDir = "${ghcjsLibDir}/package.conf.d";
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
      };
    };
    overrides = self: super: {
      inherit (self.ghc.bootPkgs) hscolour alex happy jailbreak-cabal genprimopcode;

      # Disable haddock everywhere
      mkDerivation = drv: super.mkDerivation ({ doHaddock = false; } // drv);

      # Libraries from ghc repo
      base = overrideCabal (self.callPackage (dynamicCabal2nix "${ghcFork}/libraries/base") {}) (drv: {
        extraSetupCompileFlags = [ "-Dghcjs_HOST_OS" ];
        configureFlags = [ "-v3" "--extra-include-dirs=${ghcFork}/data/include/" ];
      });
      ghc-prim = overrideCabal (self.callPackage (dynamicCabal2nix "${ghcFork}/libraries/ghc-prim") {}) (drv: {
        buildTools = (drv.buildTools or []) ++ (with stage0Pkgs; [ genprimopcode ]);
        preConfigure = ''
          cpp -P -I${ghcFork}/data/js/ ${ghcFork}/data/primops.txt.pp primops.txt
        '';

        # TODO: GRRRR we run afoul of special casing in ghc
        #       Hacking exposed modules instead
        #configureFlags = (drv.configureFlags or []) ++ [ "--flags=include-ghc-prim" ];
        postInstall = ''
          ghcjs-pkg --package-db=$packageConfDir describe ghc-prim \
            | sed '/GHC\.PrimopWrappers/ s/$/ GHC.Prim/' \
            | ghcjs-pkg --package-db=$packageConfDir update -
        '';
      });
      integer-gmp = self.callPackage (dynamicCabal2nix "${ghcFork}/libraries/integer-gmp") {};
      integer-simple = self.callPackage (dynamicCabal2nix "${ghcFork}/libraries/integer-simple") {};
      template-haskell = self.callPackage (dynamicCabal2nix "${ghcFork}/libraries/template-haskell") {};

      # Other "core" libraries
      array = self.array_0_5_1_0;
      binary = overrideCabal self.binary_0_7_6_1 (drv: {
        version = "0.7.5.0";
        sha256 = "06gg61srfva7rvzf4s63c068s838i5jf33d6cnjb9769gjmca2a7";
      });
      bytestring = overrideCabal self.bytestring_0_10_6_0 (drv: {
        # Missing import of GHC.Integer
        prePatch = ''
          sed -i Data/ByteString/Builder/ASCII.hs \
            -e '/import *GHC.Types/a import GHC.Integer'
        '';
      });
      containers = overrideCabal self.containers_0_5_7_1 (drv: {
        version = "0.5.6.2";
        sha256 = "1r9dipm2bw1dvdjyb2s1j9qmqy8xzbldgiz7a885fz0p1ygy9bdi";
      });
      deepseq = overrideCabal self.deepseq_1_4_1_2 (drv: {
        version = "1.4.1.1";
        sha256 = "1gxk6bdqfplvq0lma2sjcxl8ibix5k60g71dncpvwsmc63mmi0ch";
      });
      pretty = overrideCabal self.pretty_1_1_3_2 (drv: {
        version = "1.1.2.0";
        sha256 = "043kcl2wjip51al5kx3r9qgazq5w002q520wdgdlv2c9xr74fabw";
      });
      transformers = overrideCabal self.transformers_0_4_3_0 (drv: {
        version = "0.4.2.0";
        sha256 = "0a364zfcm17mhpy0c4ms2j88sys4yvgd6071qsgk93la2wjm8mkr";
        editedCabalFile = "1q7y5mh3bxrnxinkvgwyssgrbbl4pp183ncww8dwzgsplf0zav0n";
      });

      # GHCJS libraries
      ghcjs-prim = self.callPackage ./ghcjs-prim.nix {
        src = "${src}/ghcjs-prim";
      }; # cannot autogenerate for now
    };
  };
}
