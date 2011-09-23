{ cabal, base64Bytestring, blazeBuilder, blazeHtml, cryptohash
, fileEmbed, httpDate, httpTypes, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "0.3.3";
  sha256 = "04b4cw93agw136xjh9rssiw96vz3kxji7zh209brwfnwh13bra17";
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
