{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, text, time, transformers, wai
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "0.4.2";
  sha256 = "1k2dsjramy14rfd1j8k7zgirdfl2zybd0z0pxkvxdrgr9s2pk51y";
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
