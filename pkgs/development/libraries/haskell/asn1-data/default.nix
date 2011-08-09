{cabal, attoparsec, attoparsecEnumerator, enumerator, mtl, text} :

cabal.mkDerivation (self : {
  pname = "asn1-data";
  version = "0.5.1";
  sha256 = "10ci77pf0y8g7i1fwksv5na32jsy3brfdv6nzrnwih1brq6l5fn4";
  propagatedBuildInputs = [
    attoparsec attoparsecEnumerator enumerator mtl text
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-data";
    description = "ASN1 data reader and writer in RAW, BER, DER and CER forms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
