{ cabal, asn1Data, base64Bytestring, mtl, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "0.9.3";
  sha256 = "1gg26d1arf588zjhdzs8r26k40v6m679l8k2vw28l8j3q5m11p71";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ asn1Data base64Bytestring mtl time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "Certificates and Key Reader/Writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
