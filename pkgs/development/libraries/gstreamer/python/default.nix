{ fetchurl, stdenv, pkgconfig, python, gstreamer
  , gst-plugins-base, pygtk, pygobject3
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.4.0";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0gixsp46mv7fvhk669q60wfk9w2lc02sdb1qipq066xlrqlhrr5i";
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
