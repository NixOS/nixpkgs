{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  qtpy,

  # tests
  pyqt6,
  qt6,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pythonqwt";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "PythonQwt";
    tag = "v${version}";
    hash = "sha256-S67k5kfGqB6Ezr2XMlW3x/ya6MW6df2cFrGEqlsLOhk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    qtpy
    numpy
  ];
  nativeCheckInputs = [
    pytestCheckHook
    # Not propagating this, to allow one to choose to either choose a pyqt /
    # pyside implementation
    pyqt6
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  pythonImportsCheck = [ "qwt" ];

  meta = {
    description = "Qt plotting widgets for Python (pure Python reimplementation of Qwt C++ library)";
    homepage = "https://github.com/PlotPyStack/PythonQwt";
    changelog = "https://github.com/PlotPyStack/PythonQwt/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
