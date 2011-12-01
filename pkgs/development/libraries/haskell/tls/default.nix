{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "0.8.3";
  sha256 = "0l02kx06bf3p8rjz82d3x7cz61rh5vpb9147f4csbzfb1sgh5mzy";
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
