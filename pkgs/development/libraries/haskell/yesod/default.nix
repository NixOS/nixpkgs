{cabal, attoparsecText, blazeBuilder, hamlet, hjsmin, httpTypes,
 mimeMail, monadControl, parsec, text, transformers, unixCompat,
 wai, waiExtra, warp, yesodAuth, yesodCore, yesodForm, yesodJson,
 yesodPersistent, yesodStatic} :

cabal.mkDerivation (self : {
  pname = "yesod";
  version = "0.8.2.1";
  sha256 = "0idpgzbzy31bl5khc83wgi9a9mzrymris0mg5dlc4kj4sd5a1ksi";
  propagatedBuildInputs = [
    attoparsecText blazeBuilder hamlet hjsmin httpTypes mimeMail
    monadControl parsec text transformers unixCompat wai waiExtra warp
    yesodAuth yesodCore yesodForm yesodJson yesodPersistent yesodStatic
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Creation of type-safe, RESTful web applications.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
