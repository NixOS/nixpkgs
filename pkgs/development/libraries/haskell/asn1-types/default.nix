{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.2.2";
  sha256 = "0h3ww7iyf1xzl88mzmi03h6ws942953dr56v896vrkj3mj01hayx";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
