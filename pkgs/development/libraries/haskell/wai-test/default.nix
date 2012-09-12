{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, httpTypes, HUnit, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.0";
  sha256 = "15y0aw5c4sh1mns4ss39l0wsxrd1b6yq6m5r638x23zl6y7d9j40";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit cookie
    httpTypes HUnit text transformers wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
