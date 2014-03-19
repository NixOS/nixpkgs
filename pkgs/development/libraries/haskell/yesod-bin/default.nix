{ cabal, attoparsec, base64Bytestring, blazeBuilder, Cabal, conduit
, dataDefaultClass, fileEmbed, filepath, filesystemConduit
, fsnotify, ghcPaths, httpConduit, httpReverseProxy, httpTypes
, liftedBase, network, networkConduit, optparseApplicative, parsec
, projectTemplate, resourcet, shakespeare, shakespeareCss
, shakespeareJs, shakespeareText, split, systemFileio
, systemFilepath, tar, text, time, transformers, unixCompat
, unorderedContainers, wai, warp, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod-bin";
  version = "1.2.7.2";
  sha256 = "13mn0b144a4cfwlpq25r72a4ffngjgfdzk8rd5yk37mcsqn7yagy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder Cabal conduit
    dataDefaultClass fileEmbed filepath filesystemConduit fsnotify
    ghcPaths httpConduit httpReverseProxy httpTypes liftedBase network
    networkConduit optparseApplicative parsec projectTemplate resourcet
    shakespeare shakespeareCss shakespeareJs shakespeareText split
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
