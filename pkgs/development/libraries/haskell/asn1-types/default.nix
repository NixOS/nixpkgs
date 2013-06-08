{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.2.0";
  sha256 = "0350g5p3zbvm29nnjd554i6fyc47vmzpb42w6q46v3i9fiy23kvd";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
