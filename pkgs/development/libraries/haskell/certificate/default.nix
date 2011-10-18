{ cabal, asn1Data, base64Bytestring, mtl, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "0.9.5";
  sha256 = "0nc50x4pqsrm8q6n4xjp79q4dmmglrqd8rbryza8jmcml8fchvbz";
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
