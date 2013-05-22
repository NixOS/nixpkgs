{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "pgm";
  version = "0.1.3";
  sha256 = "1byq8bacqgdpahf57ccwwa45wf9ij0kkgp89rg9flsv1g10364d4";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/sergeyastanin/haskell-pgm";
    description = "Pure Haskell implementation of PGM image format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
