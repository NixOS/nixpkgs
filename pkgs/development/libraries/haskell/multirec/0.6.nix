{ cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.6";
  sha256 = "1k0icyz9i4hc5vfpwrv42l3q4lrnsb1bswhyyv63d9azffn5flys";
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
