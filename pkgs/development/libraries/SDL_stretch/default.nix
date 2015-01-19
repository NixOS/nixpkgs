{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation {
  name = "SDL_stretch-0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/sdl-stretch/0.3.1/SDL_stretch-0.3.1.tar.bz2";
    sha256 = "1mzw68sn4yxbp8429jg2h23h8xw2qjid51z1f5pdsghcn3x0pgvw";
  };

  buildInputs = [ SDL ];

  meta = {
     description = "Stretch Functions For SDL";
     homepage = "http://sdl-stretch.sourceforge.net/";
     license = stdenv.lib.licenses.lgpl2;
     platforms = stdenv.lib.platforms.linux;
  };
}
