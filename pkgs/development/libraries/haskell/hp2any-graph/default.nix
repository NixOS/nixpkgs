{ cabal, GLUT, glut, hp2anyCore, network, OpenGL, parseargs }:

cabal.mkDerivation (self: {
  pname = "hp2any-graph";
  version = "0.5.3";
  sha256 = "1al20pxfgkgwynrx7vr0i57342s91lcm3cnd9qjx8b6vkqmzykkq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ GLUT hp2anyCore network OpenGL parseargs ];
  extraLibraries = [ glut ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Hp2any";
    description = "Real-time heap graphing utility and profile stream server with a reusable graphing module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
