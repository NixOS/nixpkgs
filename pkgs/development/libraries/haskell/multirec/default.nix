{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "multirec";
  version = "0.7.1";
  sha256 = "1a3snlv6lr9mi4nrl4cyc5ilk6flbdn0ck2sqla6dyb2zdlgf5ph";
  buildDepends = [ Cabal ];
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
