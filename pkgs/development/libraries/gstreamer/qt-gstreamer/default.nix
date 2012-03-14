{ stdenv, fetchurl, gstreamer, gstPluginsBase, boost, glib, qt4, cmake
, automoc4, flex, bison, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${pname}-0.10.1";
  pname = "qt-gstreamer";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/${pname}/${name}.tar.bz2";
    sha256 = "0g377jlzlwgywgk7nbv9fd0aimv8wpzrymwzdiaffczxv5xvip5h";
  };

  buildInputs = [ gstreamer gstPluginsBase boost glib qt4 ];
  buildNativeInputs = [ cmake automoc4 flex bison pkgconfig ];

  patches = [ ./boost1.48.patch ];
}
