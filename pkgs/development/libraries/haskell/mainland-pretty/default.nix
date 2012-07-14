{ cabal, srcloc, symbol }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.1.3.0";
  sha256 = "1grfsn066z11737dxdk1bdhyvz9vjxxn6krfgx9bc8jin6n9h6aq";
  buildDepends = [ srcloc symbol ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
