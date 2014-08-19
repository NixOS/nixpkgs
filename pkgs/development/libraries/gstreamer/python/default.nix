{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst-plugins-base, pygtk, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.2.1";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1m7gh017f70i5pg6k9sx54ihwaizvi2dlli687gi44n5zylya8w8";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  buildInputs =
    [ pkgconfig gst-plugins-base pygtk pygobject3 ]
    ;

  preConfigure = ''
    export configureFlags="$configureFlags --with-pygi-overrides-dir=$out/lib/${python.libPrefix}/site-packages/gi/overrides"
  '';

  propagatedBuildInputs = [ gstreamer python ];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
