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
  version = "0.14.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "PythonQwt";
    tag = "v${version}";
    hash = "sha256-ZlrnCsC/is4PPUbzaMfwWSHQSQ06ksb2b/dkU8VhtSU=";
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
    changelog = "https://github.com/PlotPyStack/PythonQwt/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
