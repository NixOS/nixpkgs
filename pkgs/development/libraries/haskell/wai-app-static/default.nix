{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, byteable, cmdargs, cryptohash, cryptohashConduit, fileEmbed
, filepath, hspec, httpDate, httpTypes, mimeTypes, network
, systemFileio, systemFilepath, text, time, transformers
, unixCompat, unorderedContainers, wai, waiExtra, waiTest, warp
, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "2.0.0.5";
  sha256 = "0f18wwk0xrzbn9d6krjdcm71cyxl1pzzi5xqwzzc9xnq595m75wa";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup byteable
    cmdargs cryptohash cryptohashConduit fileEmbed filepath httpDate
    httpTypes mimeTypes systemFileio systemFilepath text time
    transformers unixCompat unorderedContainers wai waiExtra warp zlib
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
