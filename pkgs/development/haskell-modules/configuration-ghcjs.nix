{ pkgs }:

let
  removeLibraryHaskellDepends = pnames: depends:
    builtins.filter (e: !(builtins.elem (e.pname or "") pnames)) depends;

  dynamicCabal2nix = dir: pkgs.runCommand "dynamic-cabal2nix" {
    nativeBuildInputs = [ pkgs.haskellPackages.cabal2nix ];
  } "cabal2nix ${dir} > $out";
in

with import ./lib.nix { inherit pkgs; };

self: super: {
  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  # These build tools are never cross-compiled
  inherit (self.ghc.bootPkgs)
    jailbreak-cabal hscolour alex happy genprimopcode gtk2hs-buildtools rehoo hoogle;

  mkDerivation = drv: super.mkDerivation (drv
    // { doHaddock = false; } # Disable haddock everywhere
    // pkgs.lib.optionalAttrs (drv.isExecutable or false) {
      # Linker needs ghcjs-prim
      executableHaskellDepends = drv.executableHaskellDepends ++ [ self.ghcjs-prim ];
    });

  # Libraries from ghc repo
  rts = null;
  base = overrideCabal (self.callPackage (dynamicCabal2nix "${self.ghc.ghcFork}/libraries/base") {}) (drv: {
    extraSetupCompileFlags = [ "-Dghcjs_HOST_OS" ];
    configureFlags = [ "-v3" "--extra-include-dirs=${self.ghc.ghcFork}/data/include/" ];
  });
  ghc-prim = overrideCabal (self.callPackage (dynamicCabal2nix "${self.ghc.ghcFork}/libraries/ghc-prim") {}) (drv: {
    buildTools = (drv.buildTools or []) ++ (with self.ghc.bootPkgs; [ genprimopcode ]);
    preConfigure = ''
      cpp -P -I${self.ghc.ghcFork}/data/js/ ${self.ghc.ghcFork}/data/primops.txt.pp primops.txt
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
  integer-gmp = self.callPackage (dynamicCabal2nix "${self.ghc.ghcFork}/libraries/integer-gmp") {};
  integer-simple = self.callPackage (dynamicCabal2nix "${self.ghc.ghcFork}/libraries/integer-simple") {};
  template-haskell = self.callPackage (dynamicCabal2nix "${self.ghc.ghcFork}/libraries/template-haskell") {};

  # These other packages are core libraries in GHC 7.10.x
  array = self.array_0_5_1_0;
  bin-package-db = null;
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
  Cabal = assert false "Shouldn't need"; null;
  containers = overrideCabal self.containers_0_5_7_1 (drv: {
    version = "0.5.6.2";
    sha256 = "1r9dipm2bw1dvdjyb2s1j9qmqy8xzbldgiz7a885fz0p1ygy9bdi";
  });
  directory = assert false "Shouldn't need"; null;
  deepseq = overrideCabal self.deepseq_1_4_1_2 (drv: {
    version = "1.4.1.1";
    sha256 = "1gxk6bdqfplvq0lma2sjcxl8ibix5k60g71dncpvwsmc63mmi0ch";
  });
  filepath = assert false "Shouldn't need"; null;
  haskeline = self.haskeline_0_7_2_1;
  hoopl = self.hoopl_3_10_2_1;
  hpc = self.hpc_0_6_0_2;
  pretty = overrideCabal self.pretty_1_1_3_2 (drv: {
    version = "1.1.2.0";
    sha256 = "043kcl2wjip51al5kx3r9qgazq5w002q520wdgdlv2c9xr74fabw";
  });
  terminfo = self.terminfo_0_4_0_1;
  transformers = overrideCabal self.transformers_0_4_3_0 (drv: {
    version = "0.4.2.0";
    sha256 = "0a364zfcm17mhpy0c4ms2j88sys4yvgd6071qsgk93la2wjm8mkr";
    editedCabalFile = "1q7y5mh3bxrnxinkvgwyssgrbbl4pp183ncww8dwzgsplf0zav0n";
  });
  xhtml = self.xhtml_3000_2_1;

  # GHCJS libraries
  ghcjs-prim = self.callPackage ../compilers/ghcjs/ghcjs-prim.nix {
    src = "${self.ghc.src}/ghcjs-prim";
  }; # cannot autogenerate for now

  # Misc fixes
  pqueue = overrideCabal super.pqueue (drv: {
    postPatch = ''
      sed -i -e '12s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '64s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '32s|null|Data.PQueue.Internals.null|' Data/PQueue/Min.hs
      sed -i -e '32s|null|Data.PQueue.Max.null|' Data/PQueue/Max.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Internals.null|' Data/PQueue/Prio/Min.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Max.null|' Data/PQueue/Prio/Max.hs
    '';
  });

  transformers-compat = overrideCabal super.transformers-compat (drv: {
    configureFlags = [];
  });

  profunctors = overrideCabal super.profunctors (drv: {
    preConfigure = ''
      sed -i 's/^{-# ANN .* #-}//' src/Data/Profunctor/Unsafe.hs
    '';
  });

  ghcjs-ffiqq = self.callPackage
    ({ mkDerivation, base, template-haskell, ghcjs-base, split, containers, text, ghc-prim
     }:
     mkDerivation {
       pname = "ghcjs-ffiqq";
       version = "0.1.0.0";
       src = pkgs.fetchFromGitHub {
         owner = "ghcjs";
         repo = "ghcjs-ffiqq";
         rev = "da31b18582542fcfceade5ef6b2aca66662b9e20";
         sha256 = "1mkp8p9hispyzvkb5v607ihjp912jfip61id8d42i19k554ssp8y";
       };
       libraryHaskellDepends = [
         base template-haskell ghcjs-base split containers text ghc-prim
       ];
       description = "FFI QuasiQuoter for GHCJS";
       license = stdenv.lib.licenses.mit;
     }) {};

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    libraryHaskellDepends =
      removeLibraryHaskellDepends [
        "glib" "gtk" "gtk3" "webkitgtk" "webkitgtk3"
      ] drv.libraryHaskellDepends;
  });

  ghc-paths = overrideCabal super.ghc-paths (drv: {
    patches = [ ./patches/ghc-paths-nix-ghcjs.patch ];
  });

  # reflex 0.3, made compatible with the newest GHCJS.
  reflex = overrideCabal super.reflex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex";
      rev = "cc62c11a6cde31412582758c236919d4bb766ada";
      sha256 = "1j4vw0636bkl46lj8ry16i04vgpivjc6bs3ls54ppp1wfp63q7w4";
    };
  });

  # reflex-dom 0.2, made compatible with the newest GHCJS.
  reflex-dom = overrideCabal super.reflex-dom (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "ryantrinkle";
      repo = "reflex-dom";
      rev = "639d9ca13c2def075e83344c9afca6eafaf24219";
      sha256 = "0166ihbh3dbfjiym9w561svpgvj0x4i8i8ws70xaafi0cmpsxrar";
    };
    libraryHaskellDepends =
      removeLibraryHaskellDepends [
        "glib" "gtk3" "webkitgtk3" "webkitgtk3-javascriptcore" "raw-strings-qq" "unix"
      ] drv.libraryHaskellDepends;
  });

}
