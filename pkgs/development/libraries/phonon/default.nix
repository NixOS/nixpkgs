{ stdenv, fetchurl, cmake, automoc4, pulseaudio
, qt4 ? null, qt5 ? null, withQt5 ? false }:

assert (withQt5 -> qt5 != null); assert (!withQt5 -> qt4 != null);

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

  buildInputs = [ (if withQt5 then qt5 else qt4) pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  cmakeFlags = optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
