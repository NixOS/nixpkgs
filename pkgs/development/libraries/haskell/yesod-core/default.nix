{cabal, blazeBuilder, blazeHtml, caseInsensitive, cereal, clientsession,
 cookie, enumerator, failure, hamlet, httpTypes, monadControl, parsec,
 text, transformers, wai, waiExtra, webRoutesQuasi}:

cabal.mkDerivation (self : {
  pname = "yesod-core";
  version = "0.8.2";
  sha256 = "15h5nm45w3z1g4ayn0dj9grviqm857krad1453rway76yrrv7xsr";
  propagatedBuildInputs = [
    blazeBuilder blazeHtml caseInsensitive cereal clientsession
    cookie enumerator failure hamlet httpTypes monadControl parsec
    text transformers wai waiExtra webRoutesQuasi
  ];
  meta = {
    description = "Creation of type-safe, RESTful web applications";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

