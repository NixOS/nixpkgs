{cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive,
 enumerator, httpTypes, network, text, transformers, wai,
 zlibBindings} :

cabal.mkDerivation (self : {
  pname = "wai-extra";
  version = "0.4.0.3";
  sha256 = "1mfjn9rxzcfdwvimjw57j7vpr1y64ia7905c8nxa9968sdy0dhsy";
  propagatedBuildInputs = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network text transformers wai zlibBindings
  ];
  meta = {
    homepage = "http://github.com/snoyberg/wai-extra";
    description = "Provides some basic WAI handlers and middleware.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
