{ cabal, asn1Data, base64Bytestring, cryptoPubkeyTypes, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.0.1";
  sha256 = "0rv9gs316ng86zv5njcfj96zplbrn317vypnyv7sz28v4k4vha10";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data base64Bytestring cryptoPubkeyTypes mtl time
  ];
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
