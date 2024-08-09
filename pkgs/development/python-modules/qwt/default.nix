{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  qtpy,
  pyqt6,
  qt6,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qwt";
  version = "0.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "PythonQwt";
    rev = "v${version}";
    hash = "sha256-SfedLlnq8mtAg5UeHkugmYCt6RnvnlRLdjBML+P6yVs=";
  };

  dependencies = [
    numpy
    qtpy
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
    description = "Qt plotting widgets for Python (pure Python reimplementation of Qwt C++ library";
    homepage = "https://github.com/PlotPyStack/PythonQwt";
    changelog = "https://github.com/PlotPyStack/PythonQwt/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
