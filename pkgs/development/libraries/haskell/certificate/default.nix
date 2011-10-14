{ cabal, asn1Data, base64Bytestring, mtl, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "0.9.4";
  sha256 = "0apv2paxlp12ksn28bn4lb1mg05cs7sjygfarxacwmz43jy6ld9v";
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
