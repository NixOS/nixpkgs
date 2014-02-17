{ cabal, comonad, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.3.0.1";
  sha256 = "14vh6qhl6v46r857pfwkyhn8g8dh7q7vbm6z64zq1lhdw91ywn4f";
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
