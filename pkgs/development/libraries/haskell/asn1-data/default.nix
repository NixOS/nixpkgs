{ cabal, attoparsec, attoparsecEnumerator, enumerator, mtl, text }:

cabal.mkDerivation (self: {
  pname = "asn1-data";
  version = "0.6.0";
  sha256 = "0gk34x2frkk2s7d0i7ahwnjv9jcqdgx2sd1kp3d854548k171z3f";
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
