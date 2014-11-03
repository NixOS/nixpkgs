{ stdenv, fetchurl, glibmm, gstreamer, gst_plugins_base, libsigcxx, libxmlxx, pkgconfig }:

let
  ver_maj = "0.10";
  ver_min = "11";
in
stdenv.mkDerivation rec {
  name = "gstreamermm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url    = "mirror://gnome/sources/gstreamermm/${ver_maj}/gstreamermm-${ver_maj}.${ver_min}.tar.xz";
    sha256 = "12b5f377363594a69cb79f2f5cd0a8b1813ca6553680c3216e6354cfd682ebc6";
  };
 
  doCheck = false; # Tests require pulseaudio in /homeless-shelter

  propagatedBuildInputs = [
    glibmm gstreamer gst_plugins_base libsigcxx libxmlxx
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "C++ bindings for the GStreamer streaming multimedia library";
    homepage = http://www.gtkmm.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = "Philip Lykke Carlsen <plcplc@gmail.com>";
    platforms = stdenv.lib.platforms.linux;
  };

}
