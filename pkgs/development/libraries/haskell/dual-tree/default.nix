{ cabal, monoidExtras, newtype, semigroups }:

cabal.mkDerivation (self: {
  pname = "dual-tree";
  version = "0.2";
  sha256 = "0wasnjkixl6zkskjp18qj3jym3yv3a85i3w5qphgjr3xifbzwnjf";
  buildDepends = [ monoidExtras newtype semigroups ];
  jailbreak = true;
  meta = {
    description = "Rose trees with cached and accumulating monoidal annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
