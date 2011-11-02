{ cabal, aesonNative, blazeBuilder, blazeHtml, caseInsensitive
, cereal, clientsession, cookie, dataObject, dataObjectYaml
, enumerator, failure, hamlet, httpTypes, monadControl, parsec
, pathPieces, random, shakespeare, shakespeareCss, shakespeareJs
, strictConcurrency, text, time, transformers, vector, wai
, waiExtra
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.9.3.3";
  sha256 = "0qy926x009mci17fhlrcn758vc9lxybzfg16pb69ydzbdr9lqa77";
  buildDepends = [
    aesonNative blazeBuilder blazeHtml caseInsensitive cereal
    clientsession cookie dataObject dataObjectYaml enumerator failure
    hamlet httpTypes monadControl parsec pathPieces random shakespeare
    shakespeareCss shakespeareJs strictConcurrency text time
    transformers vector wai waiExtra
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
