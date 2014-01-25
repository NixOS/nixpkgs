{ cabal, cryptoApi, mtl, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "monadcryptorandom";
  version = "0.6";
  sha256 = "0gms6xsnr6g5lk36z92yygwmyrl568y1h76ww676wb3qph42xx3x";
  buildDepends = [ cryptoApi mtl tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/monadcryptorandom";
    description = "A monad for using CryptoRandomGen";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
