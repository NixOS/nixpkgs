{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, hspec, httpTypes, HUnit, network, text
, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.1.1";
  sha256 = "0daaq8kn1c35y26y7pb00sw1jyhp84zpzk6vfy1p4vfay4ppknd2";
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
