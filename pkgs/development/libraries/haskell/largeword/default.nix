{ cabal }:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.0.0";
  sha256 = "1122isizlx807zv26j0sx71iw39nn3sja6mr2pf4sd456m1vmx8r";
  meta = {
    homepage = "http://trac.haskell.org/largeword/wiki";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
