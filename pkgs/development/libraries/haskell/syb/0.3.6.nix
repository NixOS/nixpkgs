{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3.6";
  sha256 = "1khb5h4gw1f9l9zhb7x1y9rf2qpypbvm9kmpf0b6xgggd2800s25";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
