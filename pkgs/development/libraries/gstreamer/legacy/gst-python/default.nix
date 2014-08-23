{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst_plugins_base, pygtk
}:

stdenv.mkDerivation rec {
  name = "gst-python-0.10.22";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0y1i4n5m1diljqr9dsq12anwazrhbs70jziich47gkdwllcza9lg";
  };

  buildInputs =
    [ pkgconfig gst_plugins_base pygtk ]
    ;

  propagatedBuildInputs = [ gstreamer python ];
 
  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
