{ lib, stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "SDL_stretch";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/sdl-stretch/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1mzw68sn4yxbp8429jg2h23h8xw2qjid51z1f5pdsghcn3x0pgvw";
  };

  buildInputs = [ SDL ];

  meta = with lib; {
     description = "Stretch Functions For SDL";
     homepage = "https://sdl-stretch.sourceforge.net/";
     license = licenses.lgpl2;
     platforms = platforms.linux;
  };
}
