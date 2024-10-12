{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  anyqt,
  cachecontrol,
  commonmark,
  dictdiffer,
  docutils,
  filelock,
  lockfile,
  numpy,
  pip,
  qasync,
  requests-cache,
  typing-extensions,

  # tests
  qt5,
  pytest-qt,
  pytestCheckHook,

  stdenv,
}:

buildPythonPackage rec {
  pname = "orange-canvas-core";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biolab";
    repo = "orange-canvas-core";
    rev = "refs/tags/${version}";
    hash = "sha256-Jp3vCQmRdkFADStVkbCFPiCBqpbI0a4JiJ8qs60rpqw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anyqt
    cachecontrol
    commonmark
    dictdiffer
    docutils
    filelock
    lockfile
    numpy
    pip
    qasync
    requests-cache
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

  disabledTestPaths = [ "orangecanvas/canvas/items/tests/test_graphicstextitem.py" ];

  meta = {
    description = "Orange framework for building graphical user interfaces for editing workflows";
    homepage = "https://github.com/biolab/orange-canvas-core";
    changelog = "https://github.com/biolab/orange-canvas-core/releases/tag/${version}";
    license = [ lib.licenses.gpl3 ];
    maintainers = [ lib.maintainers.lucasew ];
    # Segmentation fault during tests
    broken = stdenv.hostPlatform.isDarwin;
  };
}
