{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup, Cabal
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, systemFileio, systemFilepath, tar
, text, time, transformers, unixCompat, unorderedContainers, wai
, waiExtra, warp, yaml, yesodAuth, yesodCore, yesodForm, yesodJson
, yesodPersistent, zlib
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "1.1.0.3";
  sha256 = "07rj7dyicnklp6hs1m0kjj6xz983d1zryv2f3sqhf620bc2d70fx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup Cabal filepath hamlet
    httpTypes monadControl parsec shakespeareCss shakespeareJs
    shakespeareText systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers wai waiExtra warp yaml
    yesodAuth yesodCore yesodForm yesodJson yesodPersistent zlib
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
