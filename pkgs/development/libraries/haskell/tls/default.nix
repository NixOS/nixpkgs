{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.0.2";
  sha256 = "0fkbh89j4gpwq45hv88axcdy7hxhvj1wj14nf7ma8wzaga2p4m75";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal certificate cryptoApi cryptocipher cryptohash mtl network
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
