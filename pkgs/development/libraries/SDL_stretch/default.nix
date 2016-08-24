{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  name = "SDL_stretch-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/sdl-stretch/${version}/${name}.tar.bz2";
    sha256 = "1mzw68sn4yxbp8429jg2h23h8xw2qjid51z1f5pdsghcn3x0pgvw";
  };

  buildInputs = [ SDL ];

  meta = with stdenv.lib; {
     description = "Stretch Functions For SDL";
     homepage = "http://sdl-stretch.sourceforge.net/";
     license = licenses.lgpl2;
     platforms = platforms.linux;
  };
}
