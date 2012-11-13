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
  version = "1.1.3.1";
  sha256 = "08i159w14d2i964q7ji705glg0p0zrak0pqxqi3hxyhqzp27797m";
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
