{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.0.3";
  sha256 = "14wgwz032skkgkxg2lyh8kwg1fkapmlg2jh74czbacvnssc2iidb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal certificate cryptoApi cryptocipher cryptohash mtl network
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
