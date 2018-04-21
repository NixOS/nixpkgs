{ fetchurl, stdenv, meson, ninja, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

stdenv.mkDerivation rec {
  pname = "gst-python";
  version = "1.14.0";
  name = "${pname}-${version}";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1rlr6gl4lg97ng4jxh3gb2ldmywm15vwsa72nvggr8qa2l8q3fg0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig python ];

  # XXX: in the Libs.private field of python3.pc
  buildInputs = [ ncurses ];

  mesonFlags = [
    "-Dpygi-overrides-dir=${python.sitePackages}/gi/overrides"
  ];

  postPatch = ''
    chmod +x scripts/pythondetector # patchShebangs requires executable file
    patchShebangs scripts/pythondetector
  '';

  propagatedBuildInputs = [ gst-plugins-base pygobject3 ];

  # Needed for python.buildEnv
  passthru.pythonPath = [];

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
