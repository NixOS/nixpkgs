{ cabal, cereal, certificate, cryptoApi, cryptocipher, cryptohash
, mtl
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "0.9.9";
  sha256 = "0l29ja7mcyykj4dh7awjbrb9aswgarxls71vk68pdfaz047jsvx6";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
