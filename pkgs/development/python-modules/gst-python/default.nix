{ buildPythonPackage, fetchurl, meson, ninja, stdenv, pkgconfig, python, pygobject3
, gobjectIntrospection, gst-plugins-base, isPy3k
}:

let
  pname = "gst-python";
  version = "1.14.2";
  name = "${pname}-${version}";
in buildPythonPackage rec {
  inherit pname version;
  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-python/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "08nb011acyvlz48fqh8c084k0dlssz9b7wha7zzk797inidbwh6w";
  };

  patches = [
    # Meson build does not support Python 2 at the moment
    # https://bugzilla.gnome.org/show_bug.cgi?id=796092
    (fetchurl {
      name = "0002-meson-use-new-python-module.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=371989;
      sha256 = "1k46nvw175c1wvkqnx783i9d4w9vn431spcl48jb3y224jj3va08";
    })
  ];

  # TODO: First python_dep in meson.build needs to be removed
  postPatch = ''
    substituteInPlace meson.build --replace python3 python${if isPy3k then "3" else "2"}
  '';

  nativeBuildInputs = [ meson ninja pkgconfig python gobjectIntrospection ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2"}"
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
  ];

  doCheck = true;

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  propagatedBuildInputs = [ gst-plugins-base pygobject3 ];

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
