{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, dataDefault, enumerator, httpTypes, network, text, time
, transformers, wai, zlibBindings, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.5.1";
  sha256 = "1aq0zvxyk5hgdvpydvf8hlvv61ilrsmbmdaxhiq46waaabxqgdfc";
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
