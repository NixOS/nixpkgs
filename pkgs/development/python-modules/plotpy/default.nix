{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  guidata,
  numpy,
  pillow,
  pythonqwt,
  scikit-image,
  scipy,
  tifffile,

  # tests
  pytestCheckHook,
  qt6,
  pyqt6,

  # passthru.tests
  plotpy,
  pyside6,
  qt5,
  pyqt5,
  pyside2,
}:

buildPythonPackage rec {
  pname = "plotpy";
  version = "2.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "PlotPy";
    tag = "v${version}";
    hash = "sha256-g26CWUQTaky7h1wHd9CAB4AEvk24frN7f6wqs1fefJw=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    guidata
    numpy
    pillow
    pythonqwt
    scikit-image
    scipy
    tifffile
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # Not propagating this, to allow one to choose to choose a pyqt / pyside
    # implementation.
    pyqt6
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd $out
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Segmentation fault
    # in plotpy/widgets/resizedialog.py", line 99 in __init__
    "test_resize_dialog"
    "test_tool"
  ];

  pythonImportsCheck = [
    "plotpy"
    "plotpy.tests"
  ];

  passthru = {
    tests = {
      withPyQt6 = plotpy.override {
        pyqt6 = pyqt6;
        qt6 = qt6;
      };
      withPyQt5 = plotpy.override {
        pyqt6 = pyqt5;
        qt6 = qt5;
      };
    };
    # Upstream doesn't officially supports all of them, although they use
    # qtpy, see: https://github.com/PlotPyStack/PlotPy/issues/20
    knownFailingTests = {
      # Was failing with a peculiar segmentation fault during the tests, since
      # this package was added to Nixpkgs. This is not too bad as PySide2
      # shouldn't be used for modern applications.
      withPySide2 = plotpy.override {
        pyqt6 = pyside2;
        qt6 = qt5;
      };
      # Has started failing too similarly to pyside2, ever since a certain
      # version bump. See also:
      # https://github.com/PlotPyStack/PlotPy/blob/v2.7.4/README.md?plain=1#L62
      withPySide6 = plotpy.override {
        pyqt6 = pyside6;
        qt6 = qt6;
      };
    };
  };

  meta = {
    description = "Curve and image plotting tools for Python/Qt applications";
    homepage = "https://github.com/PlotPyStack/PlotPy";
    changelog = "https://github.com/PlotPyStack/PlotPy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
