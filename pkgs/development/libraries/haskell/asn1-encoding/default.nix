{ cabal, asn1Types, mtl, text, time }:

cabal.mkDerivation (self: {
  pname = "asn1-encoding";
  version = "0.8.1.2";
  sha256 = "01i7zga9nfvccgjixnxza9mi7jj4k6308g8asnljr44s1k8rikwm";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ asn1Types mtl text time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1";
    description = "ASN1 data reader and writer in RAW, BER and DER forms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
