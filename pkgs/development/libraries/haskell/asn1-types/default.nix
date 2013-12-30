{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.2.3";
  sha256 = "1cdzhj6zls6qmy82218cj2a25b7rkxsjbcqnx4zng3wp6s5pghw4";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
