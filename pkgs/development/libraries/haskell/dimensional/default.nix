{ cabal, numtype, time }:

cabal.mkDerivation (self: {
  pname = "dimensional";
  version = "0.10.1";
  sha256 = "0pnrqm6qny09g8iy191844d0mvvyzg1j637pvwwwhci8lzq3hfyd";
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
