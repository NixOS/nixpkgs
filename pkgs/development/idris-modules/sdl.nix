{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
, SDL
, SDL_gfx
}:

build-idris-package  {
  name = "sdl";
  version = "2017-03-24";

  idrisDeps = [ prelude effects ];

  extraBuildInputs = [ idris SDL SDL_gfx ];

  src = fetchFromGitHub {
    owner = "edwinb";
    repo = "SDL-idris";
    rev = "095ce70da7ea9f163b018b690105edf375f1befe";
    sha256 = "0nryssnaqfq2pvz2mbl2kkx6mig310f9dpgrbcx788nxi0qzsig6";
  };

  meta = {
    description = "SDL-idris framework for Idris";
    homepage = https://github.com/edwinb/SDL-idris;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
