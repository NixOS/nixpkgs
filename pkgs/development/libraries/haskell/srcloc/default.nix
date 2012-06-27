{ cabal, syb, symbol }:

cabal.mkDerivation (self: {
  pname = "srcloc";
  version = "0.1.1.1";
  sha256 = "131g83sa0kjwy4bz6hcaxplywqd0899sw5r5x0nr0bffkhk91k60";
  buildDepends = [ syb symbol ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Data types for managing source code locations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
