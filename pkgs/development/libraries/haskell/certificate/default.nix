{ cabal, asn1Data, base64Bytestring, cryptoPubkeyTypes, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.1.0";
  sha256 = "10xpszfr51nd72kqmr4l1fna3bc3a272h3vf5b5hlls6k9kxzddg";
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
