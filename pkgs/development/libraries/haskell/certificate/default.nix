{ cabal, asn1Data, base64Bytestring, cryptoPubkeyTypes, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.0.0";
  sha256 = "1i4s1yvl765cfj7ya5rsvzqnijf307zh4i4pzcgncmr37mlkfjz2";
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
