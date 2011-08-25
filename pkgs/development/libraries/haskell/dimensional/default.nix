{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.10.1.1";
  sha256 = "198ynnls5l25q6igbhgd892cp1hvzca3wbgsmfxzlmcwmihhp8p9";
  buildDepends = [ numtype time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
