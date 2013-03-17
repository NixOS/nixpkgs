{ cabal, cereal, dataDefault, HUnit, idna, text, utf8String }:

cabal.mkDerivation (self: {
  pname = "publicsuffixlist";
  version = "0.0.4";
  sha256 = "0qwx2739pmmjfy6w3iri1fgyin3295vzn6rvazh34qd89i5vi3pb";
  buildDepends = [ cereal dataDefault text utf8String ];
  testDepends = [ cereal dataDefault HUnit idna text utf8String ];
  meta = {
    homepage = "https://github.com/litherum/publicsuffixlist";
    description = "Is a given string a domain suffix?";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
