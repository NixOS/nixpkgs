{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, simpleSendfile, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "0.4.6.2";
  sha256 = "1ja9w3440j69w7638wrjd6067svqcsaqdl1zklr6jx20zyadww94";
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
