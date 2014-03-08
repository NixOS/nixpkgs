{ cabal, comonad, foldl, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.4.0";
  sha256 = "0a59m46dr0am05v4b19j2saxlv0dp22kw47lck1m871y5x2gp936";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector vectorInstances
  ];
  testDepends = [
    foldl hspec QuickCheck semigroups text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
