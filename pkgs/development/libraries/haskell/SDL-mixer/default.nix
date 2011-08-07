{cabal, SDL} :

cabal.mkDerivation (self : {
  pname = "SDL-mixer";
  version = "0.6.1";
  sha256 = "1fxp5sz0w6pr5047jjvh81wkljxsl7fca239364i50m44mpcsyn1";
  propagatedBuildInputs = [ SDL ];
  meta = {
    description = "Binding to libSDL_mixer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
