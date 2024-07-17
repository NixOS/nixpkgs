{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
  SDL,
  SDL_gfx,
}:
build-idris-package {
  pname = "sdl";
  version = "2017-03-24";

  idrisDeps = [ effects ];

  extraBuildInputs = [
    SDL
    SDL_gfx
  ];

  src = fetchFromGitHub {
    owner = "edwinb";
    repo = "SDL-idris";
    rev = "095ce70da7ea9f163b018b690105edf375f1befe";
    sha256 = "0nryssnaqfq2pvz2mbl2kkx6mig310f9dpgrbcx788nxi0qzsig6";
  };

  meta = {
    description = "SDL-idris framework for Idris";
    homepage = "https://github.com/edwinb/SDL-idris";
    maintainers = [ lib.maintainers.brainrape ];
    # Can't find file sdlrun.o
    broken = true;
  };
}
