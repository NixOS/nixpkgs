{ cabal, deepseq, syb }:

cabal.mkDerivation (self: {
  pname = "symbol";
  version = "0.1.4";
  sha256 = "00318syprv1ixfbr4v7xq86z10f0psxk0b8kaxvawvacm8hp61bn";
  buildDepends = [ deepseq syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "A 'Symbol' type for fast symbol comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
