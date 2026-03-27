{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt6,
  pytestCheckHook,
  qtpy,
}:

buildPythonPackage rec {
  pname = "qtawesome";
  version = "1.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "qtawesome";
    tag = "v${version}";
    hash = "sha256-CdELoMML7j9m1HrAY8MhKcYx5Q4xuEMZIBeyzQnRQtk=";
  };

  propagatedBuildInputs = [
    pyqt6
    qtpy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Requires https://github.com/boylea/qtbot which is unmaintained
  doCheck = false;

  pythonImportsCheck = [ "qtawesome" ];

  meta = {
    description = "Iconic fonts in PyQt and PySide applications";
    mainProgram = "qta-browser";
    homepage = "https://github.com/spyder-ide/qtawesome";
    changelog = "https://github.com/spyder-ide/qtawesome/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux; # fails on Darwin
  };
}
