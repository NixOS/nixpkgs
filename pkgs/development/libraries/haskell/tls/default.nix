{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.0.1";
  sha256 = "1p0v0lrc3hkgyhczz3w9krxnnrlq1w75z4jb9vba0ygq5bxj3d53";
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
