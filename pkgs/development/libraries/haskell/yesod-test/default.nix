{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, text, time, transformers, wai
, waiTest, xmlConduit, xmlTypes, yesodCore, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.1.5";
  sha256 = "0ylm6zisz6l2rbn5dr8k0rxszgg1aa1w4ixpvai1xm6y8m17cy0i";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent text time transformers wai waiTest xmlConduit xmlTypes
    yesodCore
  ];
  testDepends = [
    hspec htmlConduit HUnit text wai xmlConduit yesodCore yesodForm
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
