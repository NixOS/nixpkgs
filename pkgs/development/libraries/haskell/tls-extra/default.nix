{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.4";
  sha256 = "1yj4v140pgvgpjv1g8h3dv00k983vjnsvdgc6y4w8ij8s4jvfbay";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
