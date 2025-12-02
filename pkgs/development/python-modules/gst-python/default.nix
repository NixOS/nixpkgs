{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  # TODO: We can get rid of this once `buildPythonPackage` accepts `finalAttrs`.
  # See: https://github.com/NixOS/nixpkgs/pull/271387
  gst-python,

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

    # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/4322
    ./skip-failing-test-not-initialized.patch
  ];

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
    # This is needed to prevent the project from looking for `gst-rtsp-server`
    # from `checkInputs`.
    #
    # TODO: This should probably be moved at least partially into the Meson hook.
    #
    # NB: We need to use `doInstallCheck` here because `buildPythonPackage`
    # renames `doCheck` to `doInstallCheck`.
    (lib.mesonEnable "tests" gst-python.doInstallCheck)
  ];

  # Tests are very flaky on Darwin.
  # See: https://github.com/NixOS/nixpkgs/issues/454955
  doCheck = !stdenv.hostPlatform.isDarwin;

  # `buildPythonPackage` uses `installCheckPhase` and leaves `checkPhase`
  # empty. It renames `doCheck` from its arguments, but not `checkPhase`.
  # See: https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "mesonCheckPhase";

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
