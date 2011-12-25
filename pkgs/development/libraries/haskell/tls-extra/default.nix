{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.2";
  sha256 = "14zi5xzdyzdzw9qv6775li635x8i9rkp2z655ygzcwz5v3spjz9z";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cryptoApi cryptocipher cryptohash mtl network text time
    tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls-extra";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
