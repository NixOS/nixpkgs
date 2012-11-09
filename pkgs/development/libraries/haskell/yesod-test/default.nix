{ cabal, attoparsec, blazeHtml, blazeMarkup, caseInsensitive, hspec
, htmlConduit, httpTypes, HUnit, monadControl, network, persistent
, poolConduit, text, transformers, wai, waiTest, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.1.1";
  sha256 = "0p3490yw0xcc62vzjk2vq32vv2ij7mcs6h28szp7y04gn6xc5nbg";
  buildDepends = [
    attoparsec blazeHtml blazeMarkup caseInsensitive hspec htmlConduit
    httpTypes HUnit monadControl network persistent poolConduit text
    transformers wai waiTest xmlConduit xmlTypes
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
