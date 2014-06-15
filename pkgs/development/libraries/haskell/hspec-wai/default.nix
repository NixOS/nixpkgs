{ cabal, aeson, aesonQq, caseInsensitive, doctest, hspec2
, hspecMeta, httpTypes, markdownUnlit, scotty, text, transformers
, wai, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "hspec-wai";
  version = "0.2.0";
  sha256 = "1hykc6k3kkjzz0x16i6ijcavsxfc003sp7fwvg2v9pzpmf9rfhhd";
  buildDepends = [
    aeson aesonQq caseInsensitive hspec2 httpTypes text transformers
    wai waiExtra
  ];
  testDepends = [
    aeson caseInsensitive doctest hspec2 hspecMeta httpTypes
    markdownUnlit scotty text transformers wai waiExtra
  ];
  meta = {
    description = "Experimental Hspec support for testing WAI applications (depends on hspec2!)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
