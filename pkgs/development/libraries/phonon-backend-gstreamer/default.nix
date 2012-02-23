{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gst_all, xz }:

let
  version = "4.6.0";
  pname = "phonon-backend-gstreamer";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0bwkd1dmj8p4m5xindh6ixfvifq36qmvfn246vx22syqfl6f1m2v";
  };

  buildInputs = [ phonon qt4 gst_all.gstreamer gst_all.gstPluginsBase ];

  buildNativeInputs = [ cmake automoc4 xz pkgconfig ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = stdenv.lib.platforms.linux;
  };  
}
