{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.6";
  sha256 = "0xdqcf7zfxpa7qmvwzxf11y61b6xn4v2jjrqpibr2pfqqr0p3gkw";
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
