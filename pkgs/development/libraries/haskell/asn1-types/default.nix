{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.1.0";
  sha256 = "1520jq65fzlpi4jfrqwry3dg4lajdk6pssb7cqbrmplda0zi2d12";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
