{ build-idris-package
, fetchFromGitHub
, effects
, lib
, pkgconfig
, SDL2
, SDL2_gfx
}:
build-idris-package rec {
  name = "sdl2";
  version = "0.1.1";

  idrisDeps = [ effects ];

  extraBuildInputs = [
    pkgconfig
    SDL2
    SDL2_gfx
  ];

  prePatch = "patchShebangs .";

  src = fetchFromGitHub {
    owner = "steshaw";
    repo = "idris-sdl2";
    rev = version;
    sha256 = "0hqhg7l6wpkdbzrdjvrbqymmahziri07ba0hvbii7dd2p0h248fv";
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
