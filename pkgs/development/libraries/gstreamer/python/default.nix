{ stdenv, fetchurl, pkgconfig
, gstreamer, pythonPackages
, ncurses
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.4.0";

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${name}.tar.xz";
    sha256 = "0gixsp46mv7fvhk669q60wfk9w2lc02sdb1qipq066xlrqlhrr5i";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  buildInputs = with pythonPackages; [
    pkgconfig gstreamer python pygobject3
    ncurses # FIXME: needed for linking with libpython3.4m.so
  ];

  preConfigure = ''
    export configureFlags="\
      --with-pygi-overrides-dir=\
        $out/lib/${pythonPackages.python.libPrefix}/site-packages/gi/overrides\
    "
  '';

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
