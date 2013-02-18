{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.3.2";
  sha256 = "0skr710fqqnna17gywaj30kpj352px2d17fwwqb832j7mj92bmv5";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent poolConduit text time transformers wai waiTest
    xmlConduit xmlTypes
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
