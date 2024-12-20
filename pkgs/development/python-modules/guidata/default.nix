{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  qtpy,
  h5py,
  requests,
  tomli,

  # tests
  pytestCheckHook,
  qt6,
  pyqt6,

  # passthru.tests
  guidata,
  pyside6,
  qt5,
  pyqt5,
  pyside2,
}:

buildPythonPackage rec {
  pname = "guidata";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "guidata";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qao10NyqFLysx/9AvORX+EIrQlnQJQhSYkVHeTwIutQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    qtpy
    h5py
    requests
    tomli
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
  '';

  pythonImportsCheck = [ "guidata" ];

  passthru = {
    tests = {
      # Should be compatible with all of these Qt implementations
      withPyQt6 = guidata.override {
        pyqt6 = pyqt6;
        qt6 = qt6;
      };
      withPySide6 = guidata.override {
        pyqt6 = pyside6;
        qt6 = qt6;
      };
      withPyQt5 = guidata.override {
        pyqt6 = pyqt5;
        qt6 = qt5;
      };
      withPySide2 = guidata.override {
        pyqt6 = pyside2;
        qt6 = qt5;
      };
    };
  };

  meta = {
    description = "Python library generating graphical user interfaces for easy dataset editing and display";
    homepage = "https://github.com/PlotPyStack/guidata";
    changelog = "https://github.com/PlotPyStack/guidata/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
