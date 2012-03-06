{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.7";
  sha256 = "1rlzdacgaq8nv0bwczsrkw47rw4aamf9y4ynm3xjw0r3w1xcg9yv";
  buildDepends = [ parsec ];
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
