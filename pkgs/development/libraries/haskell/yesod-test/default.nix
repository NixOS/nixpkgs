{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.5";
  sha256 = "095hwl1dm4mk467la68x3lilj0c056603kl0nn8ra4glcr86273j";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent poolConduit text time transformers wai waiTest
    xmlConduit xmlTypes
  ];
  testDepends = [ hspec htmlConduit HUnit xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
