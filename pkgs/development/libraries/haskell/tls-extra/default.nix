{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.2.1";
  sha256 = "0gddss5pnvrkjgjlvyl92rb78i4q8x9m6r8z01ba1snqjgldmj56";
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
