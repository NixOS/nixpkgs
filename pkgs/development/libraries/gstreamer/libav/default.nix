{ stdenv, fetchurl, pkgconfig, python, yasm
, gst-plugins-base, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-libav-1.2.2";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "585eb7971006100ad771a852e07bd2f3e23bcc6eb0b1253a40b5a0e40e4e7418";
  };

  nativeBuildInputs = [ pkgconfig python yasm ];

  buildInputs = [
    gst-plugins-base bzip2
  ];
}
