{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoApi, cryptoConduit, cryptohashCryptoapi, fileEmbed
, hspec, httpDate, httpTypes, mimeTypes, network, systemFileio
, systemFilepath, text, time, transformers, unixCompat
, unorderedContainers, wai, waiTest, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.2.1";
  sha256 = "1iw2b53p08c38fdh3d0js9j8lyy0i8qszp3jd736kzxxiig6ah79";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoApi cryptoConduit cryptohashCryptoapi fileEmbed httpDate
    httpTypes mimeTypes systemFileio systemFilepath text time
    transformers unixCompat unorderedContainers wai zlib
  ];
  testDepends = [
    hspec httpDate httpTypes mimeTypes network text time transformers
    unixCompat wai waiTest zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
