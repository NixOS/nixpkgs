{ cabal, base64Bytestring, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.6";
  sha256 = "04cvws7h2pm3rk8p2yj1pqkf9vjqq65hxg9sjldg7zhxdjgq1hgc";
  buildDepends = [
    base64Bytestring cereal cprngAes cryptoApi cryptocipher entropy
    skein tagged
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
