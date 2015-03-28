{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # LLVM is not supported on this GHC; use the latest one.
  inherit (pkgs) llvmPackages;

  jailbreak-cabal = pkgs.haskell-ng.packages.ghc7101.jailbreak-cabal;

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
    patchPhase = ''
      sed -i -e '12s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '64s|null|Data.PQueue.Internals.null|' Data/PQueue/Internals.hs
      sed -i -e '32s|null|Data.PQueue.Internals.null|' Data/PQueue/Min.hs
      sed -i -e '32s|null|Data.PQueue.Max.null|' Data/PQueue/Max.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Internals.null|' Data/PQueue/Prio/Min.hs
      sed -i -e '42s|null|Data.PQueue.Prio.Max.null|' Data/PQueue/Prio/Max.hs
    '';
  });

  reactive-banana = overrideCabal super.reactive-banana (drv: {
    patchPhase = ''
      cat >> src/Reactive/Banana/Switch.hs <<EOF
      instance Functor (AnyMoment Identity) where
        fmap = liftM
        
      instance Applicative (AnyMoment Identity) where
        pure = return
        (<*>) = ap
      EOF
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

  "ghcjs-dom" = self.callPackage
    ({ mkDerivation, base, mtl, text, ghcjs-base
     }:
     mkDerivation {
       pname = "ghcjs-dom";
       version = "0.1.1.3";
       sha256 = "0pdxb2s7fflrh8sbqakv0qi13jkn3d0yc32xhg2944yfjg5fvlly";
       buildDepends = [ base mtl text ghcjs-base ];
       description = "DOM library that supports both GHCJS and WebKitGTK";
       license = pkgs.stdenv.lib.licenses.mit;
       hydraPlatforms = pkgs.stdenv.lib.platforms.none;
     }) {};
}
