{ stdenv, fetchurl, pkgconfig, guile, buildEnv
, SDL, SDL_image, SDL_ttf, SDL_mixer
}:

stdenv.mkDerivation rec {
  pname = "guile-sdl";
  version = "0.5.2";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0cjgs012a9922hn6xqwj66w6qmfs3nycnm56hyykx5n3g5p7ag01";
  };

  nativeBuildInputs = [ pkgconfig guile ];

  buildInputs = [ SDL.dev SDL_image SDL_ttf SDL_mixer ];

  GUILE_AUTO_COMPILE = 0;

  makeFlags = let
    sdl = buildEnv {
      name = "sdl-env";
      paths = buildInputs;
    };
  in [ "SDLMINUSI=-I${sdl}/include/SDL" ];

  meta = with stdenv.lib; {
    description = "Guile bindings for SDL";
    homepage = "https://www.gnu.org/software/guile-sdl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
