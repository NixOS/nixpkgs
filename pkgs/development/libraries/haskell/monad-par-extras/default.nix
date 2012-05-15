{ cabal, abstractPar, cereal, deepseq, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-par-extras";
  version = "0.3.2";
  sha256 = "1k0j3n803z4lv5impz6xd1nzav35dl5f68nlw2ppgg1bbfpvdv6b";
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
