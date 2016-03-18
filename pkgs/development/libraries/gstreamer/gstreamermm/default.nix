{ stdenv, fetchurl, pkgconfig, file, glibmm, gst_all_1 }:

let
  ver_maj = "1.4";
  ver_min = "3";
in
stdenv.mkDerivation rec {
  name = "gstreamermm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url    = "mirror://gnome/sources/gstreamermm/${ver_maj}/${name}.tar.xz";
    sha256 = "0bj6and9b26d32bq90l8nx5wqh2ikkh8dm7qwxyxfdvmrzhixhgi";
  };
 
  nativeBuildInputs = [ pkgconfig file ];

  propagatedBuildInputs = [ glibmm gst_all_1.gst-plugins-base ];

  enableParallelBuilding = true;
 
  meta = with stdenv.lib; {
    description = "C++ interface for GStreamer";
    homepage = http://gstreamer.freedesktop.org/bindings/cplusplus.html;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.unix;
  };

}
