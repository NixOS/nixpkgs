{ cabal, abstractPar, cereal, deepseq, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-par-extras";
  version = "0.3";
  sha256 = "1nrxzqswb265slxq4dhm6bav7zb4zglbrh99w5x6hwx6drgsw10d";
  buildDepends = [
    abstractPar cereal deepseq mtl random transformers
  ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "Combinators and extra features for Par monads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
