{ cabal, bitmap, FTGL, OpenGL, stbImage }:

cabal.mkDerivation (self: {
  pname = "graphics-drawingcombinators";
  version = "1.5";
  sha256 = "064g5zcdm0xpczyf8xwx0q0yr6jrd54461qpfxbvsh90lq0pa051";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ bitmap FTGL OpenGL stbImage ];
  meta = {
    homepage = "http://github.com/luqui/graphics-drawingcombinators";
    description = "A functional interface to 2D drawing in OpenGL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
