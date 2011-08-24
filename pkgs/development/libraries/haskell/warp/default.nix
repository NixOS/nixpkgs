{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, simpleSendfile, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "0.4.3.1";
  sha256 = "19cj4jhl647gyy6nl3x2vi6v4g0y9q3w5a5lxvvfnfwgmcqnq3lk";
  buildDepends = [
    blazeBuilder blazeBuilderEnumerator caseInsensitive enumerator
    httpTypes network simpleSendfile transformers unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/snoyberg/warp";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
