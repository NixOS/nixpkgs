{ buildPythonPackage
, fetchurl
, meson
, ninja
, stdenv
, pkgconfig
, python
, pygobject3
, gobject-introspection
, gst-plugins-base
, isPy3k
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.16.2";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    sha256 = "II3zFI1z2fQW0BZWRzdYXY6nY9kSAXMtRLX+aIxiiKg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python
    gobject-introspection
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    pygobject3
  ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2"}"
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
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
