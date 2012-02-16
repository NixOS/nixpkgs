{ cabal, Cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.2";
  sha256 = "1s4hm0ilsd67ircrl0h5b72kwrw1imb3cj5z52h99bv7qjdbag03";
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
