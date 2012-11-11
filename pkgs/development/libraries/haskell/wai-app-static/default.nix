{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoConduit, cryptohash, fileEmbed, httpDate, httpTypes
, mimeTypes, systemFileio, systemFilepath, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.0.4";
  sha256 = "1dcgw6b10j5y2xa1jpqfsgcq8w6c7cdbp4pfc8nb6n54bys4linn";
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
