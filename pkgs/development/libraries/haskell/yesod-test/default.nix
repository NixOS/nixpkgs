{ cabal, attoparsec, blazeHtml, blazeMarkup, caseInsensitive, hspec
, htmlConduit, httpTypes, HUnit, monadControl, network, persistent
, poolConduit, text, transformers, wai, waiTest, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.1";
  sha256 = "0d0vg90x9rhs5ngjhpxmy6dd9hzqapiq33s9jqck003hgig4zjkw";
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
