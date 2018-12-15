{ stdenv, fetchurl, SDL2, libpng, libjpeg, libtiff, libungif, libXpm, zlib, Foundation }:

stdenv.mkDerivation rec {
  name = "SDL2_image-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_image/release/${name}.tar.gz";
    sha256 = "1b6f7002bm007y3zpyxb5r6ag0lml51jyvx1pwpj9sq24jfc8kp7";
  };

  buildInputs = [ SDL2 libpng libjpeg libtiff libungif libXpm zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin Foundation;


  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-sdltest";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage = http://www.libsdl.org/projects/SDL_image/;
    platforms = platforms.unix;
    license = licenses.zlib;
    maintainers = with maintainers; [ cpages ];
  };
}
