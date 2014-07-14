{ cabal, ftgl, OpenGL }:

cabal.mkDerivation (self: {
  pname = "FTGL";
  version = "1.333";
  sha256 = "180ahmhb06sfafmf8wfk7k6l49bcfycqkbrfny4hvcgcjg56ba1n";
  buildDepends = [ OpenGL ];
  extraLibraries = [ ftgl ];
  meta = {
    description = "Portable TrueType font rendering for OpenGL using the Freetype2 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
