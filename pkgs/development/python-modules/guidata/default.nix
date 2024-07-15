{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  qtpy,
  h5py,
  requests,
  tomli,
  pytestCheckHook,
  qt6,
  pyqt6,
}:

buildPythonPackage rec {
  pname = "guidata";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PlotPyStack";
    repo = "guidata";
    rev = "v${version}";
    hash = "sha256-zxP92BrUNmX4GjsNRuRO7UH29/HPHShSKniTYIqP148=";
  };

  dependencies = [
    numpy
    qtpy
    h5py
    requests
    tomli
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

  pythonImportsCheck = [ "guidata" ];

  meta = {
    description = "Python library generating graphical user interfaces for easy dataset editing and display";
    homepage = "https://github.com/PlotPyStack/guidata";
    changelog = "https://github.com/PlotPyStack/guidata/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
