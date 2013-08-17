{ cabal, cryptoApi, mtl, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "monadcryptorandom";
  version = "0.5.3";
  sha256 = "1nmkya9mf9y6lhmbhamq2g09pfvfpmicrwab09mcy3ggljdnnfyg";
  buildDepends = [ cryptoApi mtl tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/monadcryptorandom";
    description = "A monad for using CryptoRandomGen";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
