{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.0.1";
  sha256 = "0kkkck220wap3ad2k6461ylhshiqbizv0qh35i2325fhqx892gyr";
  buildDepends = [ Cabal ];
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
