{ cabal, comonad, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.3.0.2";
  sha256 = "1aa6dm75ff822fazdnjfgggy3y2zxa8vy4dn2vvx0y8i9pgh0m0l";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector vectorInstances
  ];
  testDepends = [
    hspec QuickCheck semigroups text transformers unorderedContainers
    vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
