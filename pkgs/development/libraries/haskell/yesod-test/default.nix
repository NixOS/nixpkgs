{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes, yesodCore
, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.0";
  sha256 = "184hfhp62jq2icyn1l6s8kvdcsa6099vmykg2nxrafg9f83lb53q";
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
