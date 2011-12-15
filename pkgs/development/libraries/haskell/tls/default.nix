{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "0.8.3.2";
  sha256 = "1g30viz94qhwv3v16d9njrwyqmv0p1hs0r11xmzx0adp806w54z9";
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
