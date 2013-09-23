{ cabal, base64Bytestring, cereal, cipherAes, cprngAes, cryptoApi
, cryptoRandom, entropy, hspec, HUnit, QuickCheck, skein, tagged
, transformers
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.9.0.3";
  sha256 = "0w7mkyrd8gx5d6mcqprn7ll05414vm2j5fbyi6pj9cxd2m4qc9b1";
  buildDepends = [
    base64Bytestring cereal cipherAes cprngAes cryptoApi cryptoRandom
    entropy skein tagged
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
