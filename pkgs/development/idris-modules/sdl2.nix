{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
  pkg-config,
  SDL2,
  SDL2_gfx,
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
    hash = "sha256-ilDYSWIyJLG1Obs1+0udvyt+FJZN99PYZo0A7j+1VMs=";
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
