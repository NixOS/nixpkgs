{ cabal, base64Bytestring, cereal, cipherAes, cprngAes, cryptoApi
, entropy, hspec, HUnit, QuickCheck, skein, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.9";
  sha256 = "0cyw34vzvv1j7w094cjcf97g8bki7l9x82s8csaf96y6d9qws308";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
