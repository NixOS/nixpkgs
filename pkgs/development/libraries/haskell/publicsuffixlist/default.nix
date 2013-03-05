{ cabal, cereal, dataDefault, HUnit, idna, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "publicsuffixlist";
  version = "0.0.3";
  sha256 = "1drsm1zp30629rzy0693ggzcx46b7ydzzafmf07mjanmn1kyyqci";
  buildDepends = [ cereal dataDefault text utf8String ];
  testDepends = [ cereal dataDefault HUnit idna text utf8String ];
  meta = {
    homepage = "https://github.com/litherum/publicsuffixlist";
    description = "Is a given string a domain suffix?";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
