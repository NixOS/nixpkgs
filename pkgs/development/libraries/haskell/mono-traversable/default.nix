{ cabal, comonad, hashable, hspec, semigroupoids, semigroups, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.1.0.0";
  sha256 = "1pkg8lagfiixgq2xb4ficgcqv1hhmxy2r49lq9szar7knh0gcjn1";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector
  ];
  testDepends = [ hspec text ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
