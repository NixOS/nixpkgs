{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.4";
  sha256 = "18sz1blnrgijcq6psqk2b5zxbizpgam1cy1vcxc4nrfryfscr42b";
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
