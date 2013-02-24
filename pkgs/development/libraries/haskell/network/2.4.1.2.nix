{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.1.2";
  sha256 = "0f7ykdv7xbsr5m3h2ml0hw3nlbnq785m0gr624pwk2s289jwakdh";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
