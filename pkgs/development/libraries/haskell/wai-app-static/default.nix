{ cabal, base64Bytestring, blazeBuilder, blazeHtml, cryptohash
, fileEmbed, httpDate, httpTypes, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.1.2";
  sha256 = "1nvzqg3wk7i2p1kcpb9f9wdzbrfl6gxid44l94mmvc7xjcmdl6qw";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml cryptohash fileEmbed
    httpDate httpTypes text time transformers unixCompat wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
