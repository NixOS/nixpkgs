{ stdenv, fetchurl, SDL, libpng, libjpeg, libtiff, libungif, libXpm }:

stdenv.mkDerivation rec {
  name = "SDL_image-1.2.12";

  src = fetchurl {
    url    = "http://www.libsdl.org/projects/SDL_image/release/${name}.tar.gz";
    sha256 = "16an9slbb8ci7d89wakkmyfvp7c0cval8xw4hkg0842nhhlp540b";
  };

  buildInputs = [ SDL libpng libjpeg libtiff libungif libXpm ];

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL/SDL.h>,' \
      -e 's,"SDL_version.h",<SDL/SDL_version.h>,' \
      -e 's,"begin_code.h",<SDL/begin_code.h>,' \
      -e 's,"close_code.h",<SDL/close_code.h>,' \
      $out/include/SDL/SDL_image.h
    ln -sv SDL/SDL_image.h $out/include/SDL_image.h
  '';

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage    = http://www.libsdl.org/projects/SDL_image/;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
