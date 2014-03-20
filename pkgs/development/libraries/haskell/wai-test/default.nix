{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, deepseq, hspec, httpTypes, network, text
, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "2.0.1";
  sha256 = "0c803l3cz5bjf60l97sy1isxhnmbpzr5x39yhnck28r0vykycnrj";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit cookie
    deepseq httpTypes network text transformers wai
  ];
  testDepends = [ hspec wai ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
