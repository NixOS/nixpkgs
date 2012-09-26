{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoConduit, cryptohash, fileEmbed, httpDate, httpTypes
, mimeTypes, systemFileio, systemFilepath, text, time, transformers
, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.0.2";
  sha256 = "0z49s4kc365q3brfkgdnja964h3h3yc3wypccnkj71dl11n040zq";
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
