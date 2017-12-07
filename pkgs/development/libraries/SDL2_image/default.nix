{ stdenv, fetchurl, SDL2, libpng, libjpeg, libtiff, libungif, libXpm, zlib }:

stdenv.mkDerivation rec {
  name = "SDL2_image-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_image/release/${name}.tar.gz";
    sha256 = "1s3ciydixrgv34vlf45ak5syq5nlfaqf19wf162lbz4ixxd0gpvj";
  };

  buildInputs = [ SDL2 libpng libjpeg libtiff libungif libXpm zlib ];

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage = http://www.libsdl.org/projects/SDL_image/;
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
