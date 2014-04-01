{ cabal, base64Bytestring, blazeBuilder, blazeHtml, blazeMarkup
, byteable, cryptohash, cryptohashConduit, fileEmbed, filepath
, hspec, httpDate, httpTypes, mimeTypes, network
, optparseApplicative, systemFileio, systemFilepath, text, time
, transformers, unixCompat, unorderedContainers, wai, waiExtra
, waiTest, warp, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-app-static";
  version = "2.0.1";
  sha256 = "1mygyp70rmhnkc0s8626cxrkvcbil92v4gnx70iz26gfb5q9lc7d";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeBuilder blazeHtml blazeMarkup byteable
    cryptohash cryptohashConduit fileEmbed filepath httpDate httpTypes
    mimeTypes optparseApplicative systemFileio systemFilepath text time
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
