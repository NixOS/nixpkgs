{ stdenv, fetchurl, cmake, gst_all_1, phonon, pkgconfig, qtbase, debug ? false }:

with stdenv.lib;

let
  version = "4.8.2";
  pname = "phonon-backend-gstreamer";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1q1ix6zsfnh6gfnpmwp67s376m7g7ahpjl1qp2fqakzb5cgzgq10";
  };

  buildInputs = with gst_all_1; [ gstreamer gst-plugins-base phonon qtbase ];

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPHONON_BUILD_PHONON4QT5=ON"
  ]
  ++ optional debug "-DCMAKE_BUILD_TYPE=Debug";

  meta = with stdenv.lib; {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = platforms.linux;
    maintainer = with maintainers; [ ttuegel ];
  };
}
