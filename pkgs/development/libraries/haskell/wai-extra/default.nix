{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, text, time, transformers, wai
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.3";
  sha256 = "07m86khgfyyadjgq8yp9kj3ljlpkvf209b1cfz2x7n5wdq8k2wm9";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network text time transformers wai zlibBindings
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
