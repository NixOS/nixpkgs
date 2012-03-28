{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "ghc-syb-utils";
  version = "0.2.1.0";
  sha256 = "02wmd4zkng38z3bhsk4w4dqj1lzznhg2p0ijwr1a0dgx8cqr490z";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://github.com/nominolo/ghc-syb";
    description = "Scrap Your Boilerplate utilities for the GHC API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
