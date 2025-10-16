{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  trubar,

  # dependencies
  anyqt,
  cachecontrol,
  commonmark,
  dictdiffer,
  docutils,
  filelock,
  lockfile,
  numpy,
  packaging,
  pip,
  qasync,
  requests,
  requests-cache,
  truststore,
  typing-extensions,

  # tests
  qt5,
  pytest-qt,
  pytestCheckHook,

  stdenv,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biolab";
    repo = "orange-canvas-core";
    tag = version;
    hash = "sha256-cEy9ADU/jZoKmGXVlqwG+qWKZ22STjALgCb1IxAwpO0=";
  };

  build-system = [
    setuptools
    trubar
  ];

  dependencies = [
    anyqt
    commonmark
    dictdiffer
    docutils
    filelock
    lockfile
    numpy
    packaging
    pip
    qasync
    requests
    requests-cache
    truststore
    typing-extensions
  ];

  pythonImportsCheck = [ "orangecanvas" ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
    export QT_QPA_PLATFORM=offscreen
  '';

  nativeCheckInputs = [
    pytest-qt
    pytestCheckHook
  ];

  disabledTests = [
    # Failed: CALL ERROR: Exceptions caught in Qt event loop
    "test_create_new_window"
    "test_dont_load_swp_on_new_window"
    "test_editlinksnode"
    "test_flattened"
    "test_links_edit"
    "test_links_edit_widget"
    "test_new_window"
    "test_toolbox"
    "test_tooltree_registry"
    "test_widgettoolgrid"
  ];

  passthru.updateScript = gitUpdater { };

  disabledTestPaths = [ "orangecanvas/canvas/items/tests/test_graphicstextitem.py" ];

  meta = {
    description = "Orange framework for building graphical user interfaces for editing workflows";
    homepage = "https://github.com/biolab/orange-canvas-core";
    changelog = "https://github.com/biolab/orange-canvas-core/releases/tag/${src.tag}";
    license = [ lib.licenses.gpl3 ];
    maintainers = [ lib.maintainers.lucasew ];
    # Segmentation fault during tests
    broken = stdenv.hostPlatform.isDarwin;
  };
}
