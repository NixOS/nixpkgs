{ fetchurl, stdenv, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gst-python";
  version = "1.12.4";
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1sm3dy10klf6i3w6a6mz0rnm29l2lxci5hr8346496jwc7v6mki0";
  };

  patches = [ ./different-path-with-pygobject.patch ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python ];

  # XXX: in the Libs.private field of python3.pc
  buildInputs = [ ncurses ];

  configureFlags = [
    "--with-pygi-overrides-dir=$(out)/${python.sitePackages}/gi/overrides"
  ];

  propagatedBuildInputs = [ gst-plugins-base pygobject3 ];

  # Needed for python.buildEnv
  passthru.pythonPath = [];

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
