{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gstreamer
, gst_plugins_base }:

let
  version = "4.7.0";
  pname = "phonon-backend-gstreamer";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0zg7hnaywk9wpcvzgskx2334cgfz09ii77pvasrn00ikcqqnnxrs";
  };

  buildInputs = [ phonon qt4 gstreamer gst_plugins_base ];

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = stdenv.lib.platforms.linux;
  };  
}
