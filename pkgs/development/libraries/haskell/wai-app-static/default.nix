{ cabal, blazeBuilder, blazeHtml, fileEmbed, httpTypes, text, time
, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "0.1.0";
  sha256 = "0k9pl1kanrb2pqp1bs5s1lxb7ayq2ddf2cxi5q2v9yq22s229xln";
  buildDepends = [
    blazeBuilder blazeHtml fileEmbed httpTypes text time transformers
    unixCompat wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
