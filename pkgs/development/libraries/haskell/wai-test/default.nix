{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, cookie, httpTypes, HUnit, text, transformers, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-test";
  version = "1.3.0.1";
  sha256 = "0yy0bvkrny4kj77wvn0cflwha6yijfxvnj530ps7xnzv1qm8qn1l";
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
