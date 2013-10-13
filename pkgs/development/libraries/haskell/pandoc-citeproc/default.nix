{ cabal, aeson, aesonPretty, attoparsec, Diff, filepath, hexpat
, hsBibutils, HTTP, json, mtl, network, pandoc, pandocTypes, parsec
, rfc5051, split, syb, tagsoup, texmath, text, time, utf8String
, vector, yaml
}:

cabal.mkDerivation (self: {
  pname = "pandoc-citeproc";
  version = "0.1.2";
  sha256 = "055msvrcqjkijkhzws48scpc4z90g0qjjsdcd0fhy309da6vax57";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec filepath hexpat hsBibutils HTTP json mtl network
    pandoc pandocTypes parsec rfc5051 split syb tagsoup texmath text
    time utf8String vector yaml
  ];
  testDepends = [ aeson aesonPretty Diff pandoc pandocTypes ];
  doCheck = false;
  meta = {
    description = "Supports using pandoc with citeproc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
