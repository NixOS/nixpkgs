{ cabal, attoparsec, blazeHtml, blazeMarkup, caseInsensitive, hspec
, htmlConduit, httpTypes, HUnit, monadControl, network, persistent
, poolConduit, text, transformers, wai, waiTest, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.0";
  sha256 = "194m4va6am2fmnsvs60jclym6bvjmwp35nyv3srbdnqwg3r983h4";
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
