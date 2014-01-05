{ cabal, monoidExtras, newtype, semigroups }:

cabal.mkDerivation (self: {
  pname = "dual-tree";
  version = "0.2.0.1";
  sha256 = "0v9kdhnwq8nv30ci5q7n43abl0wag21i06wp8pv1xgrva4lhswm5";
  buildDepends = [ monoidExtras newtype semigroups ];
  jailbreak = true;
  meta = {
    description = "Rose trees with cached and accumulating monoidal annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
