{ buildPythonPackage, fetchurl, stdenv, meson, ninja, pkgconfig, python, pygobject3
, gst-plugins-base, ncurses
}:

let
  pname = "gst-python";
  version = "1.14.2";
  name = "${pname}-${version}";
in buildPythonPackage rec {
  inherit pname version;
  format = "other";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "08nb011acyvlz48fqh8c084k0dlssz9b7wha7zzk797inidbwh6w";
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

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
