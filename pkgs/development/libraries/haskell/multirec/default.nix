{ cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.7";
  sha256 = "1n196qqggfnk8fa1x296rdbyb77a6ykhy01z8x2glgdimzpxsiay";
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic programming for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
