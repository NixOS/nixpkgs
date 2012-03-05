{ stdenv, fetchhg, SDL, libpng, libjpeg, libtiff, libungif, libXpm, automake,
  autoconf, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "SDL_image";
  version = "1.2.10-20110925";

  name = "${pname}-${version}";

  src = fetchhg {
    url = http://hg.libsdl.org/SDL_image;
    tag = "bb611e7cb1e5";
    sha256 = "0003inlvvmlc2fyrzy01lwhhfb90ppsar2skaa7x6rhmpc71dakz";
  };

  buildInputs = [SDL libpng libjpeg libtiff libungif libXpm];

  buildNativeInputs = [ automake autoconf pkgconfig ];

  patches = [ ./jpeg-linux.diff ];

  preConfigure = ''
    ./autogen.sh
    '';

  postInstall = ''
    sed -i -e 's,"SDL.h",<SDL/SDL.h>,' \
    -e 's,"SDL_version.h",<SDL/SDL_version.h>,' \
    -e 's,"begin_code.h",<SDL/begin_code.h>,' \
    -e 's,"close_code.h",<SDL/close_code.h>,' \
      $out/include/SDL/SDL_image.h

    ln -sv $out/include/SDL/SDL_image.h $out/include/
  '';

  meta = {
    description = "SDL image library";
    homepage = http://www.libsdl.org/projects/SDL_image/;
    platforms = stdenv.lib.platforms.all;
  };
}
