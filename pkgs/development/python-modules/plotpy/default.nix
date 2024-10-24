{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython_0,
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
  version = "2.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "PlotPy";
    rev = "refs/tags/v${version}";
    hash = "sha256-kMVq8X6XP18B5x35BTuC7Q5uFFwds1JxCaxlDuD/UfE=";
  };

  build-system = [
    cython_0
    setuptools
  ];
  # Both numpy versions are supported, see:
  # https://github.com/PlotPyStack/PlotPy/blob/v2.6.2/pyproject.toml#L8-L9
  postConfigure = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy >= 2.0.0' numpy
  '';

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

  pythonImportsCheck = [
    "plotpy"
    "plotpy.tests"
  ];

  passthru = {
    tests = {
      # Upstream doesn't officially supports all of them, although they use
      # qtpy, see: https://github.com/PlotPyStack/PlotPy/issues/20 . When this
      # package was created, all worked besides withPySide2, with which there
      # was a peculiar segmentation fault during the tests. In anycase, PySide2
      # shouldn't be used for modern applications.
      withPyQt6 = plotpy.override {
        pyqt6 = pyqt6;
        qt6 = qt6;
      };
      withPySide6 = plotpy.override {
        pyqt6 = pyside6;
        qt6 = qt6;
      };
      withPyQt5 = plotpy.override {
        pyqt6 = pyqt5;
        qt6 = qt5;
      };
      withPySide2 = plotpy.override {
        pyqt6 = pyside2;
        qt6 = qt5;
      };
    };
  };

  meta = {
    description = "Curve and image plotting tools for Python/Qt applications";
    homepage = "https://github.com/PlotPyStack/PlotPy";
    changelog = "https://github.com/PlotPyStack/PlotPy/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
