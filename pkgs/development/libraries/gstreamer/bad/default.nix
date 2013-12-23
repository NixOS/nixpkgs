{ stdenv, fetchurl, pkgconfig, python, gst-plugins-base, orc
, faac, faad2, libass, libkate, libmms
, libmodplug, mpeg2dec, mpg123 
, openjpeg, libopus, librsvg
, timidity, libvdpau, wayland
, libwebp, xvidcore
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.2.1";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz";
    sha256 = "f33e7c81fcb742fe50b73ad87ef8a4baa7d6b59c5002a10bf63c8dee22404929";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc
    faac faad2 libass libkate libmms
    libmodplug mpeg2dec mpg123 
    openjpeg libopus librsvg
    timidity libvdpau wayland
    libwebp xvidcore
  ];
}
