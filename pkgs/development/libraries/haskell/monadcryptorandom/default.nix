{ cabal, cryptoApi, mtl, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "monadcryptorandom";
  version = "0.5.2";
  sha256 = "0a0qx331c1kvhmwwam7pbbrnq8ky3spfnw6zsz6rz7g1lk1hfawn";
  buildDepends = [ cryptoApi mtl tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/monadcryptorandom";
    description = "A monad for using CryptoRandomGen";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
