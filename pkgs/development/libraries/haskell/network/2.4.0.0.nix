{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.0.0";
  sha256 = "1l4gdhjac7nnl4zd03bndjbjm9fizmxhimz2bznjw19q6gbp3rp0";
  buildDepends = [ parsec ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
