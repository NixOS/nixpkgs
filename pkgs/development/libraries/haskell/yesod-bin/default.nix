{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, fileEmbed, filepath, fsnotify, ghcPaths, httpConduit
, httpReverseProxy, httpTypes, liftedBase, network, networkConduit
, optparseApplicative, parsec, projectTemplate, resourcet
, shakespeare, shakespeareCss, shakespeareJs, shakespeareText
, split, systemFileio, systemFilepath, tar, text, time
, transformers, unixCompat, unorderedContainers, wai, warp, yaml
, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.3.4";
  sha256 = "0xwav5ghik0vzg706rcqlzk64gnvr4nn4iikx1bzymzz2p5zyg0z";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit fileEmbed
    filepath fsnotify ghcPaths httpConduit httpReverseProxy httpTypes
    liftedBase network networkConduit optparseApplicative parsec
    projectTemplate resourcet shakespeare shakespeareCss shakespeareJs
    shakespeareText split systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers wai warp yaml zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "The yesod helper executable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
