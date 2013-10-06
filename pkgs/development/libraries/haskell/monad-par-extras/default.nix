{ cabal, abstractPar, cereal, deepseq, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-par-extras";
  version = "0.3.3";
  sha256 = "0bl4bd6jzdc5zm20q1g67ppkfh6j6yn8fwj6msjayj621cck67p2";
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
