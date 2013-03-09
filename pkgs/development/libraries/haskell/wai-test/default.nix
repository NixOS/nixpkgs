{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, httpTypes, HUnit, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.0.4";
  sha256 = "1si54frsn8s8r0ykqc9h571rqbapf82jcvbz8bd49bbylv4j6yy0";
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
