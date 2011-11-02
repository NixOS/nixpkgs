{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, dataDefault, enumerator, httpTypes, network, text, time
, transformers, wai, zlibBindings, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.4";
  sha256 = "04mzpqa6q3ggk5r0shzc11q5qmmri566nzbsafpv2sbmiwm5s7nd";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive dataDefault
    enumerator httpTypes network text time transformers wai
    zlibBindings zlibEnum
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
