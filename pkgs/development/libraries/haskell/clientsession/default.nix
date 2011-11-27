{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher, entropy
, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.4";
  sha256 = "16blm8p0c2hk06yn5f5qmrrxwsrsdv7l7x1s07ygn8s9jmb9xyqr";
  buildDepends = [
    base64Bytestring cereal cryptoApi cryptocipher entropy skein
  ];
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
