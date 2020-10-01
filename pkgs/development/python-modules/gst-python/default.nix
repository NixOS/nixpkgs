{ buildPythonPackage
, fetchurl
, meson
, ninja
, stdenv
, pkgconfig
, python3
, pygobject3
, gobject-introspection
, gst-plugins-base
, isPy3k
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.18.0";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    sha256 = "0ifx2s2j24sj2w5jm7cxyg1kinnhbxiz4x0qp3gnsjlwbawfigvn";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    gobject-introspection
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    pygobject3
  ];

  mesonFlags = [
    "-Dpygi-overrides-dir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
  ];

  doCheck = true;

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  meta = {
    homepage = "https://gstreamer.freedesktop.org";

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
