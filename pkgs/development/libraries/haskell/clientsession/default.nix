{ cabal, base64Bytestring, cereal, cipherAes, cprngAes, cryptoApi
, entropy, hspec, HUnit, QuickCheck, skein, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.9.0.2";
  sha256 = "0vl310nickavp8wkaad1wfnvm8gfsg9jcfw3rgjz7698avynv3ni";
  buildDepends = [
    base64Bytestring cereal cipherAes cprngAes cryptoApi entropy skein
    tagged
  ];
  testDepends = [ cereal hspec HUnit QuickCheck transformers ];
  meta = {
    homepage = "http://github.com/yesodweb/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
