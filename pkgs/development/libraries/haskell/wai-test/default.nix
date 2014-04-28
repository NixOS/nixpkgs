{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, conduitExtra, cookie, deepseq, hspec, httpTypes, network
, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.1.2";
  sha256 = "11mkzh5wlfhdrwzqhsbcl3qnbawmks4vxr1vv0s2ny50q5na41ln";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit
    conduitExtra cookie deepseq httpTypes network text transformers wai
  ];
  testDepends = [ hspec wai ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
