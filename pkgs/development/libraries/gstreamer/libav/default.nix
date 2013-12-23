{ stdenv, fetchurl, pkgconfig, python, yasm
, gst-plugins-base, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-libav-1.2.1";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "fd152b7aec56ae76ad58b9759913a8bfe1792bdf64f260d0acaba75b75076676";
  };

  nativeBuildInputs = [ pkgconfig python yasm ];

  buildInputs = [
    gst-plugins-base bzip2
  ];
}
