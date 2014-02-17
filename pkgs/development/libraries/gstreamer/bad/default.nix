{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faac, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123 
, openjpeg, libopus, librsvg
, timidity, libvdpau, wayland
, libwebp, xvidcore, gnutls
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.2.3";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "1317hik9fdmy300p7c2y3aw43y6v9dr8f1906zm7s876m48pjpar";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faac faad2 libass libkate libmms
    libmodplug mpeg2dec mpg123 
    openjpeg libopus librsvg
    timidity libvdpau wayland
    libwebp xvidcore gnutls
  ];
}
