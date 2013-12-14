{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, dataDefault, fileEmbed, filepath, fsnotify, ghcPaths, httpConduit
, httpReverseProxy, httpTypes, liftedBase, network, networkConduit
, optparseApplicative, parsec, projectTemplate, resourcet
, shakespeare, shakespeareCss, shakespeareJs, shakespeareText
, split, systemFileio, systemFilepath, tar, text, time
, transformers, unixCompat, unorderedContainers, wai, warp, yaml
, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.5.2";
  sha256 = "00n957gbq03qrbwxa29hpqkmyfnbr7n4bah4185rpjdvnywq3l8x";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit dataDefault
    fileEmbed filepath fsnotify ghcPaths httpConduit httpReverseProxy
    httpTypes liftedBase network networkConduit optparseApplicative
    parsec projectTemplate resourcet shakespeare shakespeareCss
    shakespeareJs shakespeareText split systemFileio systemFilepath tar
    text time transformers unixCompat unorderedContainers wai warp yaml
    zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "The yesod helper executable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
