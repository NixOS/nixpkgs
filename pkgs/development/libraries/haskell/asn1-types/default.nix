{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.1.3";
  sha256 = "1d55vhax71d29c2b6238pz1hqp4jnyvvfhs8f05qpcv754b4s4jg";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
