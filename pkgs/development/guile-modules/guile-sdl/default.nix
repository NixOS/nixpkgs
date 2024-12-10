{
  lib,
  stdenv,
  fetchurl,
  guile,
  lzip,
  pkg-config,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  buildEnv,
}:

stdenv.mkDerivation rec {
  pname = "guile-sdl";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.lz";
    hash = "sha256-/9sTTvntkRXck3FoRalROjqUQC8hkePtLTnHNZotKOE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
    lzip
    pkg-config
    SDL
  ];

  buildInputs = [
    guile
    (lib.getDev SDL)
    SDL_image
    SDL_mixer
    SDL_ttf
  ];

  makeFlags =
    let
      sdl-env = buildEnv {
        name = "sdl-env";
        paths = buildInputs;
      };
    in
    [
      "SDLMINUSI=-I${sdl-env}/include/SDL"
    ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-sdl/";
    description = "Guile bindings for SDL";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = guile.meta.platforms;
    # configure: error: *** SDL version  not found!
    broken = stdenv.isDarwin;
  };
}
