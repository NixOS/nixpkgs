{ cabal, base64Bytestring, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.4.2";
  sha256 = "0b1afz9frky3kp2crrkmk8cvj77fnyyxrfv1ky0p0cb0lllvdhwp";
  buildDepends = [
    base64Bytestring cereal cprngAes cryptoApi cryptocipher entropy
    skein tagged
  ];
  meta = {
    homepage = "http://github.com/yesodweb/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
