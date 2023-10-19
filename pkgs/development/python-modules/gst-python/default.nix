{ lib
, buildPythonPackage
, fetchurl
, meson
, ninja

, pkg-config
, python
, pygobject3
, gobject-introspection
, gst_all_1
, isPy3k
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.22.5";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    hash = "sha256-vwUjJBXPYBgUKuUd07iXu3NDJoe1zheGv0btximM5bA=";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gst_all_1.gst-plugins-base
  ];

  propagatedBuildInputs = [
    gst_all_1.gst-plugins-base
    pygobject3
  ];

  mesonFlags = [
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
    # Exec format error during configure
    "-Dpython=${python.pythonForBuild.interpreter}"
  ];

  doCheck = true;

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  meta = with lib; {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
