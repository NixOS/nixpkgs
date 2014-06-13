{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "pgm";
  version = "0.1.4";
  sha256 = "1s3kch1qsxrfzk9sa4b0jn9vzjhw7dvh1sajgnnz97gl5y0gydmv";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/astanin/haskell-pgm";
    description = "Pure Haskell implementation of PGM image format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
