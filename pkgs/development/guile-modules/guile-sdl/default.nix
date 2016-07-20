{ stdenv, fetchurl, guile, buildEnv
, SDL, SDL_image, SDL_ttf, SDL_mixer
}:

stdenv.mkDerivation rec {
  name = "guile-sdl-0.5.1";

  meta = with stdenv.lib; {
    description = "Guile bindings for SDL";
    homepage    = "http://gnu.org/s/guile-sdl";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://gnu/guile-sdl/${name}.tar.xz";
    sha256 = "126n4rd0ydh6i2s11ari5k85iivradlf12zq13b34shf9k1wn5am";
  };

  nativeBuildInputs = [ guile ];

  buildInputs = [
    SDL.dev SDL_image SDL_ttf SDL_mixer
  ];

  GUILE_AUTO_COMPILE = 0;

  makeFlags = let
    sdl = buildEnv {
      name = "sdl-env";
      paths = buildInputs;
    };
  in "SDLMINUSI=-I${sdl}/include/SDL";
}
