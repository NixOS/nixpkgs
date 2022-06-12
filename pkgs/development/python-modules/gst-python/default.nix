{ lib
, buildPythonPackage
, fetchurl
, meson
, ninja

, pkg-config
, python
, pygobject3
, gobject-introspection
, gst-plugins-base
, isPy3k
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.20.0";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    sha256 = "j2e9xWBrozYGxryJbonefc2M9PykWfcTibG2/gdbXlQ=";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python
    gobject-introspection
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    pygobject3
  ];

  mesonFlags = [
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
  ];

  doCheck = true;

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  meta = with lib; {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = licenses.lgpl2Plus;
  };
}
