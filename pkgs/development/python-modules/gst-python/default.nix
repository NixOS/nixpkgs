{ fetchurl, stdenv, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gst-python";
  version = "1.10.4";
  name = "${pname}-${version}";

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
    export configureFlags="$configureFlags --with-pygi-overrides-dir=$out/lib/${python.sitePackages}/gi/overrides"
  '';

  propagatedBuildInputs = [ gst-plugins-base pygobject3 ];

  # Needed for python.buildEnv
  passthru.pythonPath = [];

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
