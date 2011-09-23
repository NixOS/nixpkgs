{ cabal, blazeBuilder, blazeBuilderEnumerator, caseInsensitive
, enumerator, httpTypes, network, simpleSendfile, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "0.4.5";
  sha256 = "0ql9a7qa6ivsvgr66hgj6bs8c3y8rr320kk1cxq9qbpi00gy5j8b";
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
