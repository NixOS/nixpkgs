{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, httpTypes, HUnit, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.0.2";
  sha256 = "0awr1wwhky0mbllfdan42shfckmnnf66dji5zx7rhwjdfqvbbhzn";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit cookie
    httpTypes HUnit text transformers wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Unit test framework (built on HUnit) for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
