{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.2.2";
  sha256 = "0m29vnqkkmpf4m3gi42kcbr2gfyxgkcw85xsyrq0mgbxb0zg6ky9";
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
