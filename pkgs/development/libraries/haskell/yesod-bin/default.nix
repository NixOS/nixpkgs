{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, conduitExtra, dataDefaultClass, fileEmbed, filepath, fsnotify
, ghcPaths, httpConduit, httpReverseProxy, httpTypes, liftedBase
, network, networkConduit, optparseApplicative, parsec
, projectTemplate, resourcet, shakespeare, shakespeareCss
, shakespeareJs, shakespeareText, split, streamingCommons
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unorderedContainers, wai, warp, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.7.4";
  sha256 = "1nhpn8855jhvjmh5fdvjic20lyx6k054kfp8j0lwvdcd79c7bl77";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit conduitExtra
    dataDefaultClass fileEmbed filepath fsnotify ghcPaths httpConduit
    httpReverseProxy httpTypes liftedBase network networkConduit
    optparseApplicative parsec projectTemplate resourcet shakespeare
    shakespeareCss shakespeareJs shakespeareText split streamingCommons
    systemFileio systemFilepath tar text time transformers unixCompat
    unorderedContainers wai warp yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "The yesod helper executable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
