{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes, yesodCore
, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.1";
  sha256 = "1f92q9wjj6npxfsjibw0qlg6pai721mwkjcadh121bwgrancflyr";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent poolConduit text time transformers wai waiTest
    xmlConduit xmlTypes yesodCore
  ];
  testDepends = [
    hspec htmlConduit HUnit text xmlConduit yesodCore yesodForm
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
