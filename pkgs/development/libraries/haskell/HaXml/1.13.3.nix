{ cabal }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.13.3";
  sha256 = "08d9wy0rg9m66dd10x0zvkl74l25vxdakz7xp3j88s2gd31jp1v0";
  isLibrary = true;
  isExecutable = true;
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
