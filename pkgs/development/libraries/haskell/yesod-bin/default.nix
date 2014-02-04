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
  version = "1.2.5.8";
  sha256 = "1k9afj8f463rs0w9bzxda587jhm1g3fq3l42mabydmg8mx4hbm2c";
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
