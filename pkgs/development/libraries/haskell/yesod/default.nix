{ cabal, attoparsec, blazeBuilder, blazeHtml, Cabal, fastLogger
, filepath, hamlet, httpTypes, monadControl, parsec, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers
, unixCompat, wai, waiExtra, waiLogger, warp, yesodAuth, yesodCore
, yesodForm, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod";
  version = "0.10.1.1";
  sha256 = "1d64kx0jfk1d1r4k8r57y5wz84pjxs481qdnzgjfv279y467fki6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeBuilder blazeHtml Cabal fastLogger filepath hamlet
    httpTypes monadControl parsec shakespeareCss shakespeareJs
    shakespeareText text time transformers unixCompat wai waiExtra
    waiLogger warp yesodAuth yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
