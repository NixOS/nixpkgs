{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.8";
  sha256 = "10y7spi1qwjmq7mz7h09ijrzq0jl4r02jrgxiqavsiw6j35r4yfv";
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
