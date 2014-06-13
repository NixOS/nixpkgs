{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, conduitExtra, dataDefaultClass, fileEmbed, filepath, fsnotify
, ghcPaths, httpConduit, httpReverseProxy, httpTypes, liftedBase
, network, networkConduit, optparseApplicative, parsec
, projectTemplate, resourcet, shakespeare, shakespeareCss
, shakespeareJs, shakespeareText, split, streamingCommons
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unorderedContainers, wai, waiExtra, warp, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.10.2";
  sha256 = "18faylxjrd790xv6zr77wikkcy99l7824bb1sq1y225kd7a3alsm";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit conduitExtra
    dataDefaultClass fileEmbed filepath fsnotify ghcPaths httpConduit
    httpReverseProxy httpTypes liftedBase network networkConduit
    optparseApplicative parsec projectTemplate resourcet shakespeare
    shakespeareCss shakespeareJs shakespeareText split streamingCommons
    systemFileio systemFilepath tar text time transformers unixCompat
    unorderedContainers wai waiExtra warp yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "The yesod helper executable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
