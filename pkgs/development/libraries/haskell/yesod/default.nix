{ cabal, aeson, attoparsec, base64Bytestring, blazeBuilder
, blazeHtml, blazeMarkup, Cabal, conduit, fileEmbed, filepath
, fsnotify, ghcPaths, hamlet, httpConduit, httpReverseProxy
, httpTypes, liftedBase, monadControl, network, networkConduit
, optparseApplicative, parsec, projectTemplate, resourcet
, shakespeare, shakespeareCss, shakespeareJs, shakespeareText
, split, systemFileio, systemFilepath, tar, text, time
, transformers, unixCompat, unorderedContainers, wai, waiExtra
, warp, yaml, yesodAuth, yesodCore, yesodDefault, yesodForm
, yesodJson, yesodPersistent, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.1.8.1";
  sha256 = "01s9b0pqqj7q760vm62ni95k5fqwccw8l6531kqav2vnfvi08ric";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec base64Bytestring blazeBuilder blazeHtml
    blazeMarkup Cabal conduit fileEmbed filepath fsnotify ghcPaths
    hamlet httpConduit httpReverseProxy httpTypes liftedBase
    monadControl network networkConduit optparseApplicative parsec
    projectTemplate resourcet shakespeare shakespeareCss shakespeareJs
    shakespeareText split systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers wai waiExtra warp yaml
    yesodAuth yesodCore yesodDefault yesodForm yesodJson
    yesodPersistent zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
