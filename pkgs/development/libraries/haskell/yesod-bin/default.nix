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
  version = "1.2.5.3";
  sha256 = "1fvx4sb32v5b0pflkmrqac68kq1kbx4lc4x7zri7vls6577jam5m";
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
