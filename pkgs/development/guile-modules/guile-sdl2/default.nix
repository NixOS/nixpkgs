{ stdenv,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  autoconf,
  automake,
  fetchgit,
  guile,
  libtool,
  pkgconfig
  }:
stdenv.mkDerivation rec {
  name = "guile-sdl2-${version}";
  version = "0.1.0";
  buildInputs = [ autoconf
                  automake
                  SDL2
                  SDL2_image
                  SDL2_ttf
                  SDL2_mixer
                  libtool
                  guile
                  pkgconfig ];
  src = fetchgit {
    url = "git://dthompson.us/guile-sdl2.git";
    rev = "048f80ddb5c6b03b87bba199a99a6f22d911bfff";
    sha256 = "1v7bc2bsddb46qdzq7cyzlw5i2y175kh66mbzbjky85sjfypb084";
  };
  preConfigurePhases = [ "bootstrapPhase" ];
  bootstrapPhase = ''
    ./bootstrap
  '';
  configureFlags = [ "--with-libsdl2-prefix=${SDL2}"
                     "--with-libsdl2-image-prefix=${SDL2_image}"
                     "--with-libsdl2-ttf-prefix=${SDL2_ttf}"
                     "--with-libsdl2-mixer-prefix=${SDL2_mixer}"];
  makeFlags = ["GUILE_AUTO_COMPILE=0"];
  meta = {
    description = "Bindings to SDL2 for GNU Guile";
    homepage = "https://git.dthompson.us/guile-sdl2.git";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.seppeljordan ];
    platforms = stdenv.lib.platforms.all;
  };
}
