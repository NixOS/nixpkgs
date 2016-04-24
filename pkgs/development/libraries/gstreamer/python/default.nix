{ fetchurl, stdenv, pkgconfig, python
, gst-plugins-base, pygobject3
, ncurses
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.8.0";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1spn49x7yaj69df6mxh9wwcs0y3abswkfpk84njs71lzqlbzyiff";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ pkgconfig python ];

  # XXX: in the Libs.private field of python3.pc
  buildInputs = [ ncurses ];

  preConfigure = ''
    export configureFlags="$configureFlags --with-pygi-overrides-dir=$out/lib/${python.libPrefix}/site-packages/gi/overrides"
  '';

  propagatedBuildInputs = [ gst-plugins-base pygobject3 ];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
