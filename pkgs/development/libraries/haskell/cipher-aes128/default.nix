{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cipher-aes128";
  version = "0.6";
  sha256 = "1zpxg14csb52rjsvvfcyhpl9yfyidx73zxpdsipxvb1w26p8sl7y";
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
