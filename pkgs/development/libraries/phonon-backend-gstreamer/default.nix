{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gst_all, xz }:

let version = "4.6.0"; in

stdenv.mkDerivation rec {
  name = "phonon-backend-gstreamer-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/phonon-backend-gstreamer/${version}/src/${name}.tar.xz";
    sha256 = "0bwkd1dmj8p4m5xindh6ixfvifq36qmvfn246vx22syqfl6f1m2v";
  };

  buildInputs =
    [ cmake pkgconfig phonon qt4 automoc4 xz
      gst_all.gstreamer gst_all.gstPluginsBase
    ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = stdenv.lib.platforms.linux;
  };  
}
