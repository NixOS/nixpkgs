{ cabal, filepath, polyparse, random }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.23.3";
  sha256 = "1gp3vjv8g0i9bd0sryfjarzp7n8ddfbrib68jzhqgjkqbyj2bs8g";
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
