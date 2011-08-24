{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "0.7.2";
  sha256 = "0x24jf83sfsnpvfm645lng5bc21zsbv6mbagr6q1q71zhfzfyb74";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal certificate cryptoApi cryptocipher cryptohash mtl
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
