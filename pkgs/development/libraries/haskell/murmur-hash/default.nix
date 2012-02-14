{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "murmur-hash";
  version = "0.1.0.5";
  sha256 = "1m7rm57bxkrl4i9fbvmx5m29axyxddrs4ss7plbd19pw3wsvgmr0";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://github.com/nominolo/murmur-hash";
    description = "MurmurHash2 implementation for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
