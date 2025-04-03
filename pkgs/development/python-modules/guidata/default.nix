{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  distutils,
  h5py,
  numpy,
  qtpy,
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
    tag = "v${version}";
    hash = "sha256-Qao10NyqFLysx/9AvORX+EIrQlnQJQhSYkVHeTwIutQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    distutils
    h5py
    numpy
    qtpy
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Segmentation fault
    # guidata/dataset/qtitemwidgets.py", line 633 in __init__
    "test_all_items"
    "test_loadsave_hdf5"
    "test_loadsave_json"
    # guidata/dataset/qtitemwidgets.py", line 581 in __init__
    "test_editgroupbox"
    "test_item_order"
    # guidata/qthelpers.py", line 710 in exec_dialog
    "test_arrayeditor"
  ];

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
    changelog = "https://github.com/PlotPyStack/guidata/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
