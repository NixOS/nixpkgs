{ stdenv, fetchurl, cmake, automoc4, qt4, pulseaudio }:

let
  v = "4.7.2";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/${name}.tar.xz";
    sha256 = "1ghidabmi6vnnmz8q272qi259nb8bbqlbayqk52ln98fs8s9g7l1";
  };

  buildInputs = [ qt4 pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
  };  
}
