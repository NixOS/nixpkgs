{ cabal, aeson, aesonPretty, attoparsec, filepath, hexpat
, hsBibutils, HTTP, mtl, network, pandoc, pandocTypes, parsec
, rfc5051, split, syb, tagsoup, temporary, texmath, text, time
, vector, yaml
}:

cabal.mkDerivation (self: {
  pname = "pandoc-citeproc";
  version = "0.2";
  sha256 = "0ghdkzml2rcvjf1wlpsa6ih117x56qlb3ajpbwnpwm3y4wm0jm2d";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty attoparsec filepath hexpat hsBibutils HTTP mtl
    network pandoc pandocTypes parsec rfc5051 split syb tagsoup
    temporary texmath text time vector yaml
  ];
  testDepends = [
    aeson aesonPretty filepath pandoc pandocTypes temporary text yaml
  ];
  doCheck = false;
  meta = {
    description = "Supports using pandoc with citeproc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
