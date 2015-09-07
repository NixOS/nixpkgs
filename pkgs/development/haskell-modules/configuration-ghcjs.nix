{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  inherit (pkgs.haskell.packages.ghc7102) jailbreak-cabal alex happy;

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

  dependent-map = overrideCabal super.dependent-map (drv: {
    preConfigure = ''
      sed -i 's/^.*trust base.*$//' *.cabal
    '';
  });

  profunctors = overrideCabal super.profunctors (drv: {
    preConfigure = ''
      sed -i 's/^{-# ANN .* #-}//' src/Data/Profunctor/Unsafe.hs
    '';
  });

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    buildDepends = [ self.base self.mtl self.text self.ghcjs-base ];
  });

  ghc-paths = overrideCabal super.ghc-paths (drv: {
    patches = [ ./patches/ghc-paths-nix-ghcjs.patch ];
  });

  reflex-dom = overrideCabal super.reflex-dom (drv: {
    buildDepends = [
      self.aeson self.base self.bytestring self.containers self.data-default
      self.dependent-map self.dependent-sum self.ghcjs-dom self.lens self.mtl
      self.ref-tf self.reflex self.safe self.semigroups self.text self.these
      self.time self.transformers
    ];
  });
}
