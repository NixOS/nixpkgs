{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, text, time, transformers, wai
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.0.3";
  sha256 = "1mfjn9rxzcfdwvimjw57j7vpr1y64ia7905c8nxa9968sdy0dhsy";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network text time transformers wai zlibBindings
  ];
  meta = {
    homepage = "http://github.com/snoyberg/wai-extra";
    description = "Provides some basic WAI handlers and middleware.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
