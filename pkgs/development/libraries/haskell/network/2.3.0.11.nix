{ cabal, Cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.11";
  sha256 = "1ghm8rw0m3x71pnndbmzm9j99yh8bmmrlhz4ykslsk2my7ihmxdk";
  buildDepends = [ Cabal parsec ];
  meta = {
    homepage = "http://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
