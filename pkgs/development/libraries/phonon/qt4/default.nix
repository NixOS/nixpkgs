{ stdenv, fetchurl, cmake, automoc4, libpulseaudio, qt4 }:

with stdenv.lib;

let
  v = "4.8.1";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/phonon-${v}.tar.xz";
    sha256 = "1l97h1jj3gvl1chx1qbipizfvjgqc05wrhdcflc76c2krlk03jmn";
  };

  buildInputs = [ qt4 libpulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
