{ cabal, aeson, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, dataObject, dataObjectYaml, enumerator
, failure, fastLogger, hamlet, httpTypes, monadControl, parsec
, pathPieces, random, shakespeare, shakespeareCss, shakespeareI18n
, shakespeareJs, text, time, transformers, transformersBase, vector
, wai, waiExtra, waiLogger
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.4.1";
  sha256 = "048xc8dshwpaxirz8wvk3ra0qs99wx1i145nfj7n3i6kw8qkfnz6";
  buildDepends = [
    aeson blazeBuilder blazeHtml caseInsensitive cereal clientsession
    cookie dataObject dataObjectYaml enumerator failure fastLogger
    hamlet httpTypes monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareI18n shakespeareJs text time transformers
    transformersBase vector wai waiExtra waiLogger
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
