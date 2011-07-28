{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gst_all }:

let version = "4.5.1"; in

stdenv.mkDerivation rec {
  name = "phonon-backend-gstreamer-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/phonon-backend-gstreamer/${version}/src/${name}.tar.bz2";
    sha256 = "13m3kd0iy28nsn532xl97c50vq8ci3qs2i92yk4fw428qvknqck2";
  };

  buildInputs =
    [ cmake pkgconfig phonon qt4 automoc4
      gst_all.gstreamer gst_all.gstPluginsBase
    ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
  };  
}
