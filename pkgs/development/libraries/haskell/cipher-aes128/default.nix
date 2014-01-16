{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cipher-aes128";
  version = "0.6.2";
  sha256 = "0rj56p8rcnvk95jc4fx4pxv25yk85vfad7v0znsgzp2hpw4h4ihb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "https://github.com/TomMD/cipher-aes128";
    description = "AES and common modes using AES-NI when available";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
