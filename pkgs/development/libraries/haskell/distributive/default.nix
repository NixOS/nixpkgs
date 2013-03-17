{ cabal, doctest, filepath, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.3.1";
  sha256 = "0zf3wq1xz9sbb0g6fg852jckrwkffsfkghq3zx03d2q9ginc6jbc";
  buildDepends = [ transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
