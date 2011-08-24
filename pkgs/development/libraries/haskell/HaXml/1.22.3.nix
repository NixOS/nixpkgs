{ cabal, polyparse, random }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.22.3";
  sha256 = "10gbax7nih45ck5fg056gnfgzr7zyndxpvdhvx3af2wnrmilkcbh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ polyparse random ];
  meta = {
    homepage = "http://www.cs.york.ac.uk/fp/HaXml/";
    description = "Utilities for manipulating XML documents";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
