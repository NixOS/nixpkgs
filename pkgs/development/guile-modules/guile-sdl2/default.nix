{ stdenv, fetchurl, guile, libtool, pkgconfig
, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
}:

let
  name = "${pname}-${version}";
  pname = "guile-sdl2";
  version = "0.5.0";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://files.dthompson.us/${pname}/${name}.tar.gz";
    sha256 = "118x0cg7fzbsyrfhy5f9ab7dqp9czgia0ycgzp6sn3nlsdrcnr4m";
  };

  nativeBuildInputs = [ libtool pkgconfig ];
  buildInputs = [
    guile SDL2 SDL2_image SDL2_ttf SDL2_mixer
  ];

  configureFlags = [
    "--with-libsdl2-prefix=${SDL2}"
    "--with-libsdl2-image-prefix=${SDL2_image}"
    "--with-libsdl2-ttf-prefix=${SDL2_ttf}"
    "--with-libsdl2-mixer-prefix=${SDL2_mixer}"
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  meta = with stdenv.lib; {
    description = "Bindings to SDL2 for GNU Guile";
    homepage = "https://dthompson.us/projects/guile-sdl2.html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ seppeljordan vyp ];
    platforms = platforms.all;
  };
}
