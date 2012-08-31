{ cabal, cereal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "asn1-data";
  version = "0.7.1";
  sha256 = "10s7mxygw6w8a8mx090msvbl8pji8m68lsxxyr5bp7p887naia7r";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cereal mtl text ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-data";
    description = "ASN1 data reader and writer in RAW, BER and DER forms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
