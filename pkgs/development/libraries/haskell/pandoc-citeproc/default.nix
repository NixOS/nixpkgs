{ cabal, aeson, aesonPretty, attoparsec, Diff, filepath, hexpat
, hsBibutils, HTTP, json, mtl, network, pandocTypes, parsec
, rfc5051, syb, tagsoup, texmath, text, time, utf8String, vector
, yaml
}:

cabal.mkDerivation (self: {
  pname = "pandoc-citeproc";
  version = "0.1.1.1";
  sha256 = "07h277cz5wzc2dsfqfh9lasz7ypb4pspvqljs9maj6lx5rkk5fq1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec filepath hexpat hsBibutils HTTP json mtl network
    pandocTypes parsec rfc5051 syb tagsoup texmath text time utf8String
    vector yaml
  ];
  testDepends = [ aeson aesonPretty Diff pandocTypes utf8String ];
  doCheck = false;
  meta = {
    description = "Supports using pandoc with citeproc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
