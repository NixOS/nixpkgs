{ cabal, cryptoApi, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "monadcryptorandom";
  version = "0.4";
  sha256 = "1wxqffi5x8kv0qrx82bvpvlqzzwy8vrw5ybqvf2h6cln36ff23m6";
  buildDepends = [ cryptoApi mtl transformers ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A monad for using CryptoRandomGen";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
