{ lib
, stdenv
, fetchurl
, SDL
, SDL_image
, SDL_mixer
, SDL_ttf
, buildEnv
, guile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-sdl";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-ATx1bnnDlj69h6ZUy7wd2lVsuDGS424sFCIlJQLQTzI=";
  };

  nativeBuildInputs = [
    guile
    pkg-config
  ];
  buildInputs = [
    (lib.getDev SDL)
    SDL_image
    SDL_mixer
    SDL_ttf
  ];

  makeFlags = let
    sdl-env = buildEnv {
      name = "sdl-env";
      paths = buildInputs;
    };
  in [
    "GUILE_AUTO_COMPILE=0"
    "SDLMINUSI=-I${sdl-env}/include/SDL"
  ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-sdl/";
    description = "Guile bindings for SDL";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
