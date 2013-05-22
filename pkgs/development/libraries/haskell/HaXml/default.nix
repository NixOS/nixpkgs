{ cabal, filepath, polyparse, random }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.24";
  sha256 = "18kvavqa84k2121ppxngn39fjz4w63chngb3255w1fhdz13v3ydn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath polyparse random ];
  meta = {
    homepage = "http://www.cs.york.ac.uk/fp/HaXml/";
    description = "Utilities for manipulating XML documents";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
