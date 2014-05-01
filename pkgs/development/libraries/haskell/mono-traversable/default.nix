{ cabal, comonad, dlist, dlistInstances, foldl, hashable, hspec
, QuickCheck, semigroupoids, semigroups, text, transformers
, unorderedContainers, vector, vectorAlgorithms, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.5.0";
  sha256 = "1dbsysg7r32ni15rvm21g41ivcgggns8nx9r797bbkid9n8fs1ja";
  buildDepends = [
    comonad dlist dlistInstances hashable semigroupoids semigroups text
    transformers unorderedContainers vector vectorAlgorithms
    vectorInstances
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
