{ cabal, filepath, freeglut, GLUT, hp2anyCore, mesa, network
, OpenGL, parseargs
}:

cabal.mkDerivation (self: {
  pname = "hp2any-graph";
  version = "0.5.4";
  sha256 = "1lhp9saw51w09fhk94hz31rjawnnxavd7x3lxjc8xn1778wp3v9h";
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
