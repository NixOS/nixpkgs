{ stdenv, fetchurl, cmake, automoc4, qt4, xz, pulseaudio }:

let
  v = "4.6.0";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/src/${name}.tar.xz";
    sha256 = "2915e7a37c92a0a8237b9e6d2ef67ba8b005ee3529d03991cd3d137f039ba3c4";
  };

  buildInputs = [ qt4 pulseaudio ];

  buildNativeInputs = [ cmake automoc4 xz ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = "LGPLv2";
    platforms = stdenv.lib.platforms.linux;
  };  
}
