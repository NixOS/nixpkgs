{ stdenv, fetchurl, cmake, automoc4, pulseaudio, qt5 }:

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

  buildInputs = [ qt5 pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  cmakeFlags = ["-DPHONON_BUILD_PHONON4QT5=ON"];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
