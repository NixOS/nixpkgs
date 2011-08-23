{ cabal, SDL, SDL_mixer }:

cabal.mkDerivation (self: {
  pname = "SDL-mixer";
  version = "0.6.1";
  sha256 = "1fxp5sz0w6pr5047jjvh81wkljxsl7fca239364i50m44mpcsyn1";
  buildDepends = [ SDL ];
  extraLibraries = [ SDL_mixer ];
  meta = {
    description = "Binding to libSDL_mixer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
