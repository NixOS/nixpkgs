{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, guile
, lzip
, pkg-config
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SDL
, SDL_image
, SDL_mixer
, SDL_ttf
, buildEnv
<<<<<<< HEAD
=======
, guile
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "guile-sdl";
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (lib.getDev SDL)
    SDL_image
    SDL_mixer
    SDL_ttf
  ];

<<<<<<< HEAD
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
=======
  makeFlags = let
    sdl-env = buildEnv {
      name = "sdl-env";
      paths = buildInputs;
    };
  in [
    "GUILE_AUTO_COMPILE=0"
    "SDLMINUSI=-I${sdl-env}/include/SDL"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://www.gnu.org/software/guile-sdl/";
    description = "Guile bindings for SDL";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
<<<<<<< HEAD
    platforms = guile.meta.platforms;
    # configure: error: *** SDL version  not found!
    broken = stdenv.isDarwin;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
