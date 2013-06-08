{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, hspec, httpTypes, HUnit, network, text
, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.1";
  sha256 = "0dw9lbwb27yr3953ill0r727ivqav5b2ica8gbaalvnh3h5c8akg";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit cookie
    httpTypes HUnit network text transformers wai
  ];
  testDepends = [ hspec wai ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
