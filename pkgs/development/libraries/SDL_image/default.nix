{ stdenv, fetchurl, SDL, libpng, libjpeg, libtiff, libungif, libXpm }:

stdenv.mkDerivation rec {
  name = "SDL_image-${version}";
  version = "1.2.12";

  src = fetchurl {
    url    = "http://www.libsdl.org/projects/SDL_image/release/${name}.tar.gz";
    sha256 = "16an9slbb8ci7d89wakkmyfvp7c0cval8xw4hkg0842nhhlp540b";
  };

  buildInputs = [ SDL libpng libjpeg libtiff libungif libXpm ];

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage    = "http://www.libsdl.org/projects/SDL_image/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
