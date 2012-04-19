{ cabal, cryptoApi, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "monadcryptorandom";
  version = "0.4.1";
  sha256 = "01x3zfr4m93bgx062rhxqk1d8qhn6s7rkfkm4yf00p89fclyjsg1";
  buildDepends = [ cryptoApi mtl transformers ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A monad for using CryptoRandomGen";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
