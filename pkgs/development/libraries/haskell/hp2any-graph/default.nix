{ cabal, filepath, freeglut, GLUT, hp2anyCore, mesa, network
, OpenGL, parseargs
}:

cabal.mkDerivation (self: {
  pname = "hp2any-graph";
  version = "0.5.4.1";
  sha256 = "0cvli36lbipi29fw45mfpv35dn7ndbkxhpd3wjy9xn9gy8g0r9xx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath GLUT hp2anyCore network OpenGL parseargs
  ];
  extraLibraries = [ freeglut mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Hp2any";
    description = "Real-time heap graphing utility and profile stream server with a reusable graphing module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
