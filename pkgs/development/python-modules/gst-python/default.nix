{ fetchurl, stdenv, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gst-python";
  version = "1.12.2";
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0iwy0v2k27wd3957ich6j5f0f04b0wb2mb175ypf2lx68snk5k7l";
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
