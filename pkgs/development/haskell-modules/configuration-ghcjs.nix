{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  inherit (pkgs.haskell.packages.ghc7102) jailbreak-cabal alex happy gtk2hs-buildtools;

  # Many packages fail with:
  #   haddock: internal error: expectJust getPackageDetails
  mkDerivation = drv: super.mkDerivation (drv // { doHaddock = false; });

  # This is the list of packages that are built into a booted ghcjs installation
  # It can be generated with the command:
  # nix-shell '<nixpkgs>' -A pkgs.haskellPackages_ghcjs.ghc --command "ghcjs-pkg list | sed -n 's/^    \(.*\)-\([0-9.]*\)$/\1_\2/ p' | sed 's/\./_/g' | sed 's/-\(.\)/\U\1/' | sed 's/^\([^_]*\)\(.*\)$/\1 = null;/'"
  Cabal = null;
  aeson = null;
  array = null;
  async = null;
  attoparsec = null;
  base = null;
  binary = null;
  rts = null;
  bytestring = null;
  case-insensitive = null;
  containers = null;
  deepseq = null;
  directory = null;
  dlist = null;
  extensible-exceptions = null;
  filepath = null;
  ghc-prim = null;
  ghcjs-base = null;
  ghcjs-prim = null;
  hashable = null;
  integer-gmp = null;
  mtl = null;
  old-locale = null;
  old-time = null;
  parallel = null;
  pretty = null;
  primitive = null;
  process = null;
  scientific = null;
  stm = null;
  syb = null;
  template-haskell = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  unordered-containers = null;
  vector = null;

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

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    buildDepends = [ self.base self.mtl self.text self.ghcjs-base ];
    libraryHaskellDepends = [ ];
    src = pkgs.fetchFromGitHub {
      owner = "ghcjs";
      repo = "ghcjs-dom";
      rev = "8d77202b46cbf0aed77bb1f1e8d827f27dee90d7";
      sha256 = "01npi286mwg7yr3h9qhxnylnjzbjb4lg5235v5lqfwy76hmmb9lp";
    };
  });

  ghc-paths = overrideCabal super.ghc-paths (drv: {
    patches = [ ./patches/ghc-paths-nix-ghcjs.patch ];
  });

  # reflex 0.3, made compatible with the newest GHCJS.
  reflex = overrideCabal super.reflex (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "k0001";
      repo = "reflex";
      rev = "e9b2f777ad07875149614e8337507afd5b1a2466";
      sha256 = "005hr3s6y369pxfdlixi4wabgav0bb653j98788kq9q9ssgijlwn";
    };
    libraryHaskellDepends = [
      self.base self.containers self.dependent-map_0_1_1_3
      self.dependent-sum_0_2_0_1 self.exception-transformers self.mtl
      self.primitive self.ref-tf self.semigroups self.template-haskell
      self.these self.transformers self.transformers-compat
    ];
  });

  # reflex-dom 0.2, made compatible with the newest GHCJS.
  reflex-dom = overrideCabal super.reflex-dom (drv: {
    src = pkgs.fetchFromGitHub {
      owner = "k0001";
      repo = "reflex-dom";
      rev = "a117eae8e101198977611f87605a5cb2ae752fc7";
      sha256 = "18m8ng2fgsfbqdvx5jxy23ndyyhafnxflq8apg5psdz3aqkfimzh";
    };
    libraryHaskellDepends = [
      self.aeson self.base self.bifunctors self.bytestring self.containers
      self.data-default self.dependent-map_0_1_1_3 self.dependent-sum_0_2_0_1
      self.dependent-sum-template self.directory
      self.exception-transformers self.ghcjs-dom self.lens self.mtl self.ref-tf
      self.reflex self.safe self.semigroups self.text self.these self.time
      self.transformers
    ];
  });

  # required by reflex, reflex-dom
  dependent-map_0_1_1_3 = self.callPackage (
    { mkDerivation, base, containers, dependent-sum_0_2_0_1, stdenv
    }:
    mkDerivation {
      pname = "dependent-map";
      version = "0.1.1.3";
      sha256 = "1by83rrv8dfn5lxrpx3qzs1lg31fhnzlqy979h8ampyxd0w93pa4";
      libraryHaskellDepends = [ base containers dependent-sum_0_2_0_1 ];
      homepage = "https://github.com/mokus0/dependent-map";
      description = "Dependent finite maps (partial dependent products)";
      license = "unknown";
    }
  ) {};

  # required by reflex, reflex-dom
  dependent-sum_0_2_0_1 = self.callPackage (
    { mkDerivation, base, stdenv
    }:
    mkDerivation {
      pname = "dependent-sum";
      version = "0.2.1.0";
      sha256 = "1h6wsrh206k6q3jcfdxvlsswbm47x30psp6x30l2z0j9jyf7jpl3";
      libraryHaskellDepends = [ base ];
      homepage = "https://github.com/mokus0/dependent-sum";
      description = "Dependent sum type";
      license = stdenv.lib.licenses.publicDomain;
    }
  ) {};

  # required by reflex-dom
  dependent-sum-template = overrideCabal super.dependent-sum-template (drv: {
    libraryHaskellDepends = [
      self.base self.dependent-sum_0_2_0_1 self.template-haskell self.th-extras
    ];
  });

}
