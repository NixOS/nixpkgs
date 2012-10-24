{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.0.0";
  sha256 = "1d82s5h75dh1bqi592q8gm37wnmpl6n2zajz03n51qysa6w90cvm";
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
