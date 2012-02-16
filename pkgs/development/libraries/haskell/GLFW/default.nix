{ cabal, libX11, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLFW";
  version = "0.5.0.1";
  sha256 = "1zjxw0fn1am9n4bwqn8jwp14cdgyg1cv5v8rrg2bisggw7wdc4c6";
  buildDepends = [ OpenGL ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/GLFW";
    description = "A Haskell binding for GLFW";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
