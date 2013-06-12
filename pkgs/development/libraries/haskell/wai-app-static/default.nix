{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, cereal, cryptoConduit, cryptohash, fileEmbed, hspec, httpDate
, httpTypes, mimeTypes, network, systemFileio, systemFilepath, text
, time, transformers, unixCompat, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "1.3.1.3";
  sha256 = "0h6m1an3srkvyaz50w16v2mhjyfdqbqq2d7ng3yhrrmb1fyvhas1";
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup cereal
    cryptoConduit cryptohash fileEmbed httpDate httpTypes mimeTypes
    systemFileio systemFilepath text time transformers unixCompat wai
  ];
  testDepends = [
    hspec httpDate httpTypes mimeTypes network text time transformers
    unixCompat wai waiTest
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "WAI application for static serving";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
