{ cabal, attoparsec, base64Bytestring, blazeBuilder, blazeHtml
, blazeMarkup, Cabal, conduit, fileEmbed, filepath, fsnotify
, ghcPaths, hamlet, httpConduit, httpReverseProxy, httpTypes
, liftedBase, monadControl, network, optparseApplicative, parsec
, projectTemplate, resourcet, shakespeare, shakespeareCss
, shakespeareJs, shakespeareText, split, systemFileio
, systemFilepath, tar, text, time, transformers, unixCompat
, unorderedContainers, wai, waiExtra, warp, yaml, yesodAuth
, yesodCore, yesodDefault, yesodForm, yesodJson, yesodPersistent
, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.1.4";
  sha256 = "1na50j7cd89mxk7ss67xlj703spvkpzcwgp7qs1pn2x3xsm7vrm2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder blazeHtml blazeMarkup
    Cabal conduit fileEmbed filepath fsnotify ghcPaths hamlet
    httpConduit httpReverseProxy httpTypes liftedBase monadControl
    network optparseApplicative parsec projectTemplate resourcet
    shakespeare shakespeareCss shakespeareJs shakespeareText split
    systemFileio systemFilepath tar text time transformers unixCompat
    unorderedContainers wai waiExtra warp yaml yesodAuth yesodCore
    yesodDefault yesodForm yesodJson yesodPersistent zlib
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
