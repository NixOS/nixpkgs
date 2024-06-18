{ build-idris-package
, fetchFromGitHub
, effects
, lib
, pkg-config
, SDL2
, SDL2_gfx
}:
build-idris-package rec {
  pname = "sdl2";
  version = "0.1.1";

  idrisDeps = [ effects ];

  nativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    SDL2
    SDL2_gfx
  ];

  prePatch = "patchShebangs .";

  src = fetchFromGitHub {
    owner = "steshaw";
    repo = "idris-sdl2";
    rev = version;
    sha256 = "1jslnlzyw04dcvcd7xsdjqa7waxzkm5znddv76sv291jc94xhl4a";
  };

  meta = {
    description = "SDL2 binding for Idris";
    homepage = "https://github.com/steshaw/idris-sdl2";
    maintainers = with lib.maintainers; [
      brainrape
      steshaw
    ];
  };
}
