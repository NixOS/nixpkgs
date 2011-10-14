{ cabal, attoparsec, attoparsecEnumerator, enumerator, mtl, text }:

cabal.mkDerivation (self: {
  pname = "asn1-data";
  version = "0.6.1";
  sha256 = "1kj1h1z4ix8kdxq5838xk70sgz9rq0vdii5nli1rcycx3y2ipi84";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecEnumerator enumerator mtl text
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-data";
    description = "ASN1 data reader and writer in RAW, BER, DER and CER forms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
