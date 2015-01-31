{ stdenv, fetchurl, xz, vlc, cmake, pkgconfig, phonon_qt5, qt5 }:

with stdenv.lib;

let
  pname = "phonon-backend-vlc";
  v = "0.8.2";
  # Force same Qt version in phonon and VLC
  vlc_ = vlc.override {
    inherit qt5;
    qt4 = null;
    withQt5 = true;
  };
  phonon_ = phonon.override { inherit qt4 qt5 withQt5; };
in

stdenv.mkDerivation {
  name = "${pname}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${v}/src/${pname}-${v}.tar.xz";
    sha256 = "18ysdga681my75lxxv5h242pa4qappvg5z73wnc0ks9yypnzidys";
  };

  nativeBuildInputs = [ cmake pkgconfig xz ];

  buildInputs = [ vlc_ phonon_qt5 qt5];

  cmakeFlags = ["-DPHONON_BUILD_PHONON4QT5=ON"];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "VideoLAN backend for Phonon multimedia framework";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel urkud ];
    license = licenses.lgpl21Plus;
  };
}
