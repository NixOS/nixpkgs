{
  lib,
  buildPythonPackage,
  fetchurl,
  meson,
  ninja,

  pkg-config,
  python,
  pygobject3,
  gobject-introspection,
  gst_all_1,
  isPy3k,
  directoryListingUpdater,
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.26.0";

  format = "other";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-python/gst-python-${version}.tar.xz";
    hash = "sha256-5QRqBdd6uxVnGtAc0ZCNF9YuWgb114Qb5DQq3io/uNs=";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gst_all_1.gst-plugins-base
  ];

  buildInputs = [
    # for gstreamer-analytics-1.0
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = [
    gst_all_1.gst-plugins-base
    pygobject3
  ];

  checkInputs = [
    gst_all_1.gst-rtsp-server
  ];

  mesonFlags = [
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
    # Exec format error during configure
    "-Dpython-exe=${python.pythonOnBuildForHost.interpreter}"
  ];

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  passthru = {
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = licenses.lgpl2Plus;
    maintainers = [ ];
  };
}
