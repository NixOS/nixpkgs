{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faac, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123 
, openjpeg, libopus, librsvg
, timidity, libvdpau, wayland
, libwebp, xvidcore, gnutls
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.2.2";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "63e78db11b482d0529a0bde01e2ac23fd32c7cb99a5508b53ee4ca1051871b2c";
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
