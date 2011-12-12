{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, dataDefault, enumerator, httpTypes, network, text, time
, transformers, wai, zlibBindings, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.5.2";
  sha256 = "05gq22il1jnvw5rcqr6gassxj29f8l4536zm6bpgk1kff8cxa3g1";
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
