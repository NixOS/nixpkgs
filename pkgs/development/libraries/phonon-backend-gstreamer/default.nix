{ stdenv, fetchurl, cmake, automoc4, pkgconfig, gst_all_1
, phonon, qt4 ? null, qt5 ? null, withQt5 ? false }:

with stdenv.lib;

assert (withQt5 -> qt5 != null); assert (!withQt5 -> qt4 != null);

let
  version = "4.8.0";
  pname = "phonon-backend-gstreamer";
  qt = if withQt5 then qt5 else qt4;
  # Force same Qt version in phonon
  phonon_ = phonon.override { inherit qt4 qt5 withQt5; };
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/${name}.tar.xz";
    sha256 = "0zjqf1gpj6h9hj27225vihg5gj0fjgvh4n9nkrbij7kf57bcn6gq";
  };

  buildInputs = with gst_all_1; [ phonon_ qt gstreamer gst-plugins-base ];

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  cmakeFlags =
    [ "-DCMAKE_INSTALL_LIBDIR=lib"
    ] ++ optional withQt5 "-DPHONON_BUILD_PHONON4QT5=ON";

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21Plus;
  };
}
