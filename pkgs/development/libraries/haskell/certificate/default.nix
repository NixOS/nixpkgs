{ cabal, asn1Data, base64Bytestring, cryptoPubkeyTypes, mtl, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.1.1";
  sha256 = "1n9sj69haqsiny1zn1lb09q86ga4ccypbdbkxsk5bzv10ygkk7d9";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
