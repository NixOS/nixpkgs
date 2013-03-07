{ stdenv, fetchurl, gstreamer, gst_plugins_base, boost, glib, qt4, cmake
, automoc4, flex, bison, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-0.10.2";
  pname = "qt-gstreamer";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/${pname}/${name}.tar.bz2";
    sha256 = "1laryg5vgc3prdi7dmpfwa71nsrc3ngv27sgax44c4qfrgpsgwbf";
  };

  buildInputs = [ gstreamer gst_plugins_base glib qt4 ];
  propagatedBuildInputs = [ boost ];
  nativeBuildInputs = [ cmake automoc4 flex bison pkgconfig ];

  cmakeFlags = "-DUSE_QT_PLUGIN_DIR=OFF -DUSE_GST_PLUGIN_DIR=OFF";

  patches = [ ./boost1.48.patch ];
}
