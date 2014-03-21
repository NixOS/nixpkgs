{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, hspec, httpTypes, HUnit, network, text
, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.0.2";
  sha256 = "0085whb8jav2zasmgi8z62anm6i509lc2w0988vqlcrds7rrknc8";
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
