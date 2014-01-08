{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cipher-aes128";
  version = "0.6.1";
  sha256 = "0alvsz6l3ihjbl2ygml6k117j4z3485d7ny6cjv1cz3by688s76g";
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
