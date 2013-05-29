{ cabal, SDL, SDL_ttf }:

cabal.mkDerivation (self: {
  pname = "SDL-ttf";
  version = "0.6.2";
  sha256 = "0jajnbqnhdd4i8pj8j27m53zwgfs1v06kiwy0s0zml02fdkq8j4a";
  buildDepends = [ SDL ];
  extraLibraries = [ SDL_ttf ];
  meta = {
    description = "Binding to libSDL_ttf";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
