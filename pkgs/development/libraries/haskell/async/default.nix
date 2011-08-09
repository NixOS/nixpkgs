{ cabal }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "1.2";
  sha256 = "a5963d36fc1ba142d18920f967190b25cf80f700d863372b6d33ad5257a1773a";
  meta = {
    homepage = "http://gitorious.org/async/";
    description = "Asynchronous Computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
