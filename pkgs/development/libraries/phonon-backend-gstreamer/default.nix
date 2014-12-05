{ stdenv, fetchurl, cmake, automoc4, qt4, pkgconfig, phonon, gstreamer
, gst_plugins_base }:

let
  version = "4.7.2";
  pname = "phonon-backend-gstreamer";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1cfjk450aajr8hfhnfq7zbmryprxiwr9ha5x585dsh7mja82mdw0";
  };

  buildInputs = [ phonon qt4 gstreamer gst_plugins_base ];

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = {
    homepage = http://phonon.kde.org/;
    description = "GStreamer backend for Phonon";
    platforms = stdenv.lib.platforms.linux;
  };  
}
