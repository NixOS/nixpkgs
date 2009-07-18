{cabal, HAppSServer, HStringTemplate, HTTP, SHA, cgi, datetime,
 filestore, highlightingKate, mtl, network, pandoc, parsec,
 recaptcha, utf8String, xhtml, zlib}:

cabal.mkDerivation (self : {
  pname = "gitit";
  version = "0.5.3";
  sha256 = "d8e1c319e52edc6f2e92d1d22b8995f38b31f6aa0b6649aa73877e889ff45851";
  propagatedBuildInputs =
    [HAppSServer HStringTemplate HTTP SHA cgi datetime filestore
     highlightingKate mtl network pandoc parsec recaptcha utf8String
     xhtml zlib];
  meta = {
    description = "Wiki using HAppS, git or darcs, and pandoc";
  };
})  

