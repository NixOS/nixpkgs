{cabal, SDL, SDL_mixer}:

cabal.mkDerivation (self : {
  pname = "SDL-mixer";
  version = "0.5.5";
  sha256 = "0e1b07a0cbe22eafff7b36f53e4ea840abad50131a867cb70d47beaf902fd185";
  propagatedBuildInputs = [SDL SDL_mixer];
  meta = {
    description = "Binding to libSDL_mixer";
  };
})

