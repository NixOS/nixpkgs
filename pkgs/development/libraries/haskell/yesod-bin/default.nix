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
  version = "1.2.8";
  sha256 = "0hic32k1ii1j2hrwxj7pc7vv26dmq8rv7h7as1fw0bwlysrnw8nm";
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
