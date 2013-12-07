{ stdenv, fetchurl, cmake, automoc4, qt4, pulseaudio }:

let
  v = "4.7.0";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/${name}.tar.xz";
    sha256 = "1sxrnwm16dxy32xmrqf26762wmbqing1zx8i4vlvzgzvd9xy39ac";
  };

  buildInputs = [ qt4 pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = "LGPLv2";
    platforms = stdenv.lib.platforms.linux;
  };  
}
