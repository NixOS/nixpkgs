{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "asn1-types";
  version = "0.2.1";
  sha256 = "1gnyvinimxb9vw3gwvsdvja8ascm07v9f5grxh42fzqkx6fm5xvr";
  buildDepends = [ time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-asn1-types";
    description = "ASN.1 types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
