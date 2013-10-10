{ cabal, aeson, aesonPretty, attoparsec, Diff, filepath, hexpat
, hsBibutils, HTTP, json, mtl, network, pandoc, pandocTypes, parsec
, rfc5051, syb, tagsoup, texmath, text, time, utf8String, vector
, yaml
}:

cabal.mkDerivation (self: {
  pname = "pandoc-citeproc";
  version = "0.1.1.2";
  sha256 = "02bs9wb3x1p9fs4kixchmvyyrhrkmx0qkwv22qmy4gsp90sc8q8i";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec filepath hexpat hsBibutils HTTP json mtl network
    pandocTypes parsec rfc5051 syb tagsoup texmath text time utf8String
    vector yaml
  ];
  testDepends = [ aeson aesonPretty Diff pandoc pandocTypes ];
  doCheck = false;
  meta = {
    description = "Supports using pandoc with citeproc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
