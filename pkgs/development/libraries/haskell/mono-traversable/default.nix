{ cabal, comonad, foldl, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.3.1";
  sha256 = "0a0vy0hp34sw1q7153jd614mqydzg79pw645kfxlihs3j7ac2b3j";
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
