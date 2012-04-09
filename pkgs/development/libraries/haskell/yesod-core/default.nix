{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, conduit, cookie, failure, fastLogger, hamlet
, httpTypes, liftedBase, monadControl, parsec, pathPieces, random
, resourcet, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiLogger, yesodRoutes
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "1.0.0.2";
  sha256 = "0l6mfgcw0jmm941w7s0df091hm1c1v66p8sc89xjqzcwvdhcnyyd";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    conduit cookie failure fastLogger hamlet httpTypes liftedBase
    monadControl parsec pathPieces random resourcet shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra waiLogger yesodRoutes
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
