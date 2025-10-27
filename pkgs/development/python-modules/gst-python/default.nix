{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  fetchpatch,
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

  patches = [
    # Fix segfault with PyGObject>=3.52.0
    # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/8653
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/69bba61e548c7a63bc18137e63e41489a7de9d36.patch";
      stripLen = 2;
      hash = "sha256-BfWPc8dsB09KiEm9bNT8e+jH76jiDefQlEhhLJoq7tI=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # The analytics tests often timeout under load on Darwin (e.g. on Hydra), so remove them
    substituteInPlace testsuite/meson.build --replace-fail \
      "['Test analytics', 'test_analytics.py', ['gst-plugins-bad/gst-libs/gst/analytics', 'gst-plugins-base/gst-libs/gst/video']]," \
      ""
  '';

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

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${gst_all_1.gst-plugins-base}/lib"
  '';

  passthru = {
    updateScript = directoryListingUpdater { };
  };

  meta = {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
  };
}
