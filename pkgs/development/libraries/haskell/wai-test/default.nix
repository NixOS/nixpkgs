{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, conduitExtra, cookie, deepseq, hspec, httpTypes, network
, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.1.3";
  sha256 = "18j77l2n41941f95awj6fj0w712628v5lsc3bif00cqnaixjmz48";
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
