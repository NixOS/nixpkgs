{ cabal, filepath, polyparse, random }:

cabal.mkDerivation (self: {
  pname = "HaXml";
  version = "1.22.5";
  sha256 = "1ckmi8iwyaid4mcnh8117s9kq45f8r7sidh6dbhzbj0dl29rrkbz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath polyparse random ];
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
