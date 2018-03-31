{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
, pkgconfig
, SDL2
, SDL2_gfx
}:

build-idris-package  {
  name = "sdl2";
  version = "2018-01-19";

  idrisDeps = [ prelude effects ];

  extraBuildInputs = [ idris pkgconfig SDL2 SDL2_gfx ];

  src = fetchFromGitHub {
    owner = "steshaw";
    repo = "idris-sdl2";
    rev = "ebc36a0efb3e8086f2999120e7a8a8ac4952c6f6";
    sha256 = "060k0i1pjilrc4pcz7v70hbipaw2crz14yxjlyjlhn6qm03131q0";
  };

  meta = {
    description = "SDL2 binding for Idris";
    homepage = https://github.com/steshaw/idris-sdl2;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
