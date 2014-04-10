{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, conduitExtra, cookie, deepseq, hspec, httpTypes, network
, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.1.1";
  sha256 = "08mkn6v8kxlcn2qb5rz9m5mqzl9wy43mxs2jzl1gavkf9bhwc93s";
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
