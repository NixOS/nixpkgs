{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoConduit, cryptohash, fileEmbed, httpDate, httpTypes
, mimeTypes, systemFileio, systemFilepath, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.1";
  sha256 = "0r2ghx3nqh7nms8yxa874h5pyagj993r077f8riybjyjp078s2lk";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoConduit cryptohash fileEmbed httpDate httpTypes mimeTypes
    systemFileio systemFilepath text time transformers unixCompat wai
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/wai";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
