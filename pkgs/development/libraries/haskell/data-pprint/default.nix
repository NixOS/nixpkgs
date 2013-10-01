{ cabal, deepseq, mtl, parallel, time }:

cabal.mkDerivation (self: {
  pname = "data-pprint";
  version = "0.2.1.5";
  sha256 = "0dalm41l93303rraxi9kipxkm11a0mly3w488afj700ny5v6l9ij";
  buildDepends = [ deepseq mtl parallel time ];
  meta = {
    description = "Prettyprint and compare Data values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
