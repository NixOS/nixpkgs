{ fetchurl, stdenv, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gst-python";
  version = "1.12.3";
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "19rb06x2m7103zwfm0plxx95gb8bp01ng04h4q9k6ii9q7g2kxf3";
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
