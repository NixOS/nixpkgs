{ stdenv, fetchurl, cmake, automoc4, qt, pulseaudio, useQt5 ? false }:

let
  v = "4.8.0";
in

stdenv.mkDerivation rec {
  name = if useQt5 then "phonon4qt5-${v}" else "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/phonon-${v}.tar.xz";
    sha256 = "096m3v4i7gmn0870l1bifna5bwbii6xrdk29i98s9i9zr1k2mjrv";
  };

  buildInputs = [ qt pulseaudio ];

  nativeBuildInputs = [ cmake automoc4 ];

  cmakeFlags = with stdenv.lib; optional useQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
