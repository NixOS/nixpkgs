{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3.3";
  sha256 = "0jskxbnzariq2ahcymvjrp4bhl9cpflc1nh51whdl9axcrd5c901";
  buildDepends = [ Cabal ];
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
