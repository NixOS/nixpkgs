{ fetchurl, stdenv, pkgconfig, python
, gst-plugins-base, pygobject3
, ncurses
}:

stdenv.mkDerivation rec {
  name = "gst-python-1.8.2";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "15sdfa6lq5pswvi09vk51cs30yf8wr2rlm9myhb4q0c2jhiial2g";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  outputs = [ "out" "dev" ];

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
