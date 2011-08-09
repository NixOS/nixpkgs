{ cabal, polyparse }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.20.2";
  sha256 = "05kmr2ablinnrg3x1xr19g5kzzby322lblvcvhwbkv26ajwi0b63";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ polyparse ];
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
