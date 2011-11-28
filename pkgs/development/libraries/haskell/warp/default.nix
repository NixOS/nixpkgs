{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, simpleSendfile, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "0.4.6.1";
  sha256 = "0gybcxfg619nws0j3ybimd8qg2knb1byk8cpcsdligp4yifp4qwd";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network simpleSendfile transformers unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
