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
  version = "1.26.11";

  pyproject = false;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/gst-python/gst-python-${version}.tar.xz";
    hash = "sha256-ETFrp2m1bSbYsUZMcZipkkyurkgTT321kXH68ac9xDY=";
  };

  # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/4322
  postPatch = ''
    substituteInPlace testsuite/meson.build \
      --replace-fail "['gstinit', 'test_gst_init.py']," ""
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
    # This is needed to prevent the project from looking for `gst-rtsp-server`
    # from `checkInputs`.
    #
    # TODO: This should probably be moved at least partially into the Meson hook.
    #
    # NB: We need to use `doInstallCheck` here because `buildPythonPackage`
    # renames `doCheck` to `doInstallCheck`.
    (lib.mesonEnable "tests" gst-python.doInstallCheck)
  ];

  # `buildPythonPackage` uses `installCheckPhase` and leaves `checkPhase`
  # empty. It renames `doCheck` from its arguments, but not `checkPhase`.
  # See: https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = ''
    runHook preCheck
    mesonCheckPhase
    runHook postCheck
  '';

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${gst_all_1.gst-plugins-base}/lib"
  '';

  passthru = {
    updateScript = directoryListingUpdater { odd-unstable = true; };
  };

  meta = {
    homepage = "https://gstreamer.freedesktop.org";
    description = "Python bindings for GStreamer";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
  };
}
