{ cabal, Cabal, failure }:

cabal.mkDerivation (self: {
  pname = "attempt";
  version = "0.4.0";
  sha256 = "0n7srd1gy1fa0q1qzizvdgmrc078jyx47115aw85vvl74vh9qyjy";
  buildDepends = [ Cabal failure ];
  meta = {
    homepage = "http://github.com/snoyberg/attempt/tree/master";
    description = "Concrete data type for handling extensible exceptions as failures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
