{cabal, blazeBuilder, text} :

cabal.mkDerivation (self : {
  pname = "cookie";
  version = "0.3.0";
  sha256 = "0ix7g29a7kj48yx2dqjj1g6vy89rmidsnjfnfj7mali86q9i7bdw";
  propagatedBuildInputs = [ blazeBuilder text ];
  meta = {
    homepage = "http://github.com/snoyberg/cookie";
    description = "HTTP cookie parsing and rendering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
