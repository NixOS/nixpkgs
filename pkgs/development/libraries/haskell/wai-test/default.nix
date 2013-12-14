{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, hspec, httpTypes, HUnit, network, text
, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.0.1";
  sha256 = "1lk7i9kiawsn56f8w2nidmas6g94yq7diaprvkd7c52hjki5mla7";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit cookie
    httpTypes HUnit network text transformers wai
  ];
  testDepends = [ hspec wai ];
  postBuild = ":";
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
