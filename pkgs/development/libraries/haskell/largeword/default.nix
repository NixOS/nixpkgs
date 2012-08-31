{ cabal }:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.0.3";
  sha256 = "18b6nhq1cww4wdbrfq0cb828kncxzcsibgs5dbgxa66y6iw93vkg";
  meta = {
    homepage = "http://trac.haskell.org/largeword/wiki";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
