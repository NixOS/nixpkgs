{ cabal, base64Bytestring, blazeBuilder, blazeHtml, cryptohash
, fileEmbed, httpDate, httpTypes, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "0.3.5.1";
  sha256 = "0pk7biyfg8za2i85vawgf3mxglbhk7bfl9xmiswqk6ppwwq2q4xb";
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
