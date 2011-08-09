{ cabal, asn1Data, base64Bytestring, mtl, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "0.9.1";
  sha256 = "0hq9a0vz72kk1n3hdza36rji8vc95y667iwcsmsh5habyh6q8228";
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
