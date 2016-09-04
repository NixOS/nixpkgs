{ stdenv, fetchurl, SDL2, libpng, libjpeg, libtiff, libungif, libXpm, zlib }:

stdenv.mkDerivation rec {
  name = "SDL2_image-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/SDL_image/release/${name}.tar.gz";
    sha256 = "0r3z1l7fdn76qkpy7snpkcjqz8dkv2zp6lsqpq25q4m5xsyaygis";
  };

  buildInputs = [ SDL2 libpng libjpeg libtiff libungif libXpm zlib ];

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage = "http://www.libsdl.org/projects/SDL_image/";
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
