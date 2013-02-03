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
  version = "1.1.8";
  sha256 = "0ygcsrq8nf1jvksig72r3i13qz1d3hgh5476fy6l4wl33idk6jb1";
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
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
