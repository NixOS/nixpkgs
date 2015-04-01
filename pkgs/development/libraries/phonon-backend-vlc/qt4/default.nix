{ stdenv, fetchurl, xz, vlc, automoc4, cmake, pkgconfig, phonon
, qt4 ? null, qt5 ? null, withQt5 ? false }:

with stdenv.lib;

assert (withQt5 -> qt5 != null); assert (!withQt5 -> qt4 != null);

let
  pname = "phonon-backend-vlc";
  v = "0.8.1";
  # Force same Qt version in phonon and VLC
  vlc_ = vlc.override { inherit qt4 qt5 withQt5; };
  phonon_ = phonon.override { inherit qt4 qt5 withQt5; };
in

stdenv.mkDerivation {
  name = "${pname}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/${pname}-${v}.tar.xz";
    sha256 = "1fyfh7qyb6rld350v2fgz452ld96d3z5ifchr323q0vc3hb9k222";
  };

  nativeBuildInputs = [ cmake pkgconfig automoc4 xz ];

  buildInputs = [ vlc_ phonon_ (if withQt5 then qt5 else qt4)];

  cmakeFlags = optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "VideoLAN backend for Phonon multimedia framework";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel urkud ];
    license = licenses.lgpl21Plus;
  };
}
