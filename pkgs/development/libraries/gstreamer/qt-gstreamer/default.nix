{ stdenv, fetchurl, gst_all_1, boost, glib, qt4, cmake
, automoc4, flex, bison, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-1.2.0";
  pname = "qt-gstreamer";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/${pname}/${name}.tar.xz";
    sha256 = "9f3b492b74cad9be918e4c4db96df48dab9c012f2ae5667f438b64a4d92e8fd4";
  };

  buildInputs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base glib qt4 ];
  propagatedBuildInputs = [ boost ];
  nativeBuildInputs = [ cmake automoc4 flex bison pkgconfig ];

  cmakeFlags = "-DUSE_QT_PLUGIN_DIR=OFF -DUSE_GST_PLUGIN_DIR=OFF";
}
