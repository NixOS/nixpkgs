{ cabal, blazeBuilder, blazeHtml, caseInsensitive, cereal
, clientsession, cookie, enumerator, failure, hamlet, httpTypes
, monadControl, parsec, text, time, transformers, wai, waiExtra
, webRoutesQuasi
}:

cabal.mkDerivation (self: {
  pname = "yesod-core";
  version = "0.8.3.2";
  sha256 = "0k0lgd9p8mrwwcypx1nfr1z2rq5wk4gvjc1fbvla0c9nabqnbfzs";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder blazeHtml caseInsensitive cereal clientsession cookie
    enumerator failure hamlet httpTypes monadControl parsec text time
    transformers wai waiExtra webRoutesQuasi
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
