{cabal, SDL, SDL_ttf}:

cabal.mkDerivation (self : {
  pname = "SDL-ttf";
  version = "0.5.5";
  sha256 = "577109d01fca61c103520e7bf33e45af118bcb6d15fcd6da7a8b72c43c69cbb6";
  propagatedBuildInputs = [SDL SDL_ttf];
  meta = {
    description = "Binding to libSDL_ttf";
  };
})

