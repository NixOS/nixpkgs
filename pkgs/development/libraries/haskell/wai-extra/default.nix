{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, dataDefault, enumerator, fastLogger, httpTypes, network, text
, time, transformers, wai, zlibBindings, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.6";
  sha256 = "1wpdfzw5qzbd33iypgppp4822vn7vhja6y26dnkb17n08r83vvhv";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive dataDefault
    enumerator fastLogger httpTypes network text time transformers wai
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
