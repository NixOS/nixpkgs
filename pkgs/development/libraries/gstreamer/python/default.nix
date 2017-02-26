{ fetchurl, stdenv, pkgconfig, pythonPackages
, gst-plugins-base
, ncurses
}:

let
  inherit (pythonPackages) python pygobject3;
in stdenv.mkDerivation rec {
  name = "gst-python-1.10.4";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "04l2hvvz9b0f3nyds1k3yfk5di8a91fpr6maj19c11mwp1s82l2r";
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
