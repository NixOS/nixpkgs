{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "0.8.0";
  sha256 = "05c7bizwkwcp83idsa5cjb53lvm9f44iaypp9yiqv4ly9q3h315q";
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
