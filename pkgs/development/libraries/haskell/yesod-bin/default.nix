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
  version = "1.2.5.5";
  sha256 = "1dgbrdvfr5n4nxrm86sp2njf0kjnv0rapf28wy76j9qkisvn905k";
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
