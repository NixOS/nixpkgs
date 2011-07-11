{cabal, GLUT, OpenGL, hp2anyCore, network, parseargs}:

cabal.mkDerivation (self : {
  pname = "hp2any-graph";
  version = "0.5.3";
  sha256 = "1al20pxfgkgwynrx7vr0i57342s91lcm3cnd9qjx8b6vkqmzykkq";
  propagatedBuildInputs = [GLUT OpenGL hp2anyCore network parseargs];
  meta = {
    description = "Real-time heap graphing utility and profile stream server with a reusable graphing module";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

