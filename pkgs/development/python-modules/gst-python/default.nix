{ lib
, buildPythonPackage
, fetchurl
, meson
, ninja

, pkg-config
, python3
, pygobject3
, gobject-introspection
, gst-plugins-base
, isPy3k
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.18.4";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    sha256 = "13h9qzfz8s1gyj2ar9q2gf5346sgdv6jv8hj7aw0hpl2gs5f0s6b";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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

  meta = with lib; {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = licenses.lgpl2Plus;
  };
}
