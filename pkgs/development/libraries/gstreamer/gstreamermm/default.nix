{ stdenv, fetchurl, pkgconfig, file, glibmm, gst_all_1 }:

let
  ver_maj = "1.10";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gstreamermm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url    = "mirror://gnome/sources/gstreamermm/${ver_maj}/${name}.tar.xz";
    sha256 = "0q4dx9sncqbwgpzma0zvj6zssc279yl80pn8irb95qypyyggwn5y";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig file ];

  propagatedBuildInputs = [ glibmm gst_all_1.gst-plugins-base ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface for GStreamer";
    homepage = https://gstreamer.freedesktop.org/bindings/cplusplus.html;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };

}
