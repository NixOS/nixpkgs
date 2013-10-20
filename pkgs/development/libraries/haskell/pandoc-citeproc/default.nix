{ cabal, aeson, aesonPretty, attoparsec, Diff, filepath, hexpat
, hsBibutils, HTTP, json, mtl, network, pandoc, pandocTypes, parsec
, rfc5051, split, syb, tagsoup, texmath, text, time, utf8String
, vector, yaml
}:

cabal.mkDerivation (self: {
  pname = "pandoc-citeproc";
  version = "0.1.2.1";
  sha256 = "13i4shpbd9swbsrpmkpb7jx79m12z12m9f3x167fs78509dak3iv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec filepath hexpat hsBibutils HTTP json mtl network
    pandoc pandocTypes parsec rfc5051 split syb tagsoup texmath text
    time utf8String vector yaml
  ];
  testDepends = [
    aeson aesonPretty Diff filepath pandoc pandocTypes yaml
  ];
  doCheck = false;
  meta = {
    description = "Supports using pandoc with citeproc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
