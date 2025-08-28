{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  pytestCheckHook,
  pythonOlder,
  qtpy,
}:

buildPythonPackage rec {
  pname = "qtawesome";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "qtawesome";
    tag = "v${version}";
    hash = "sha256-VjUlP+5QU9ApD09UNvF48b0gepCUpVO6U6zYaKm0KoE=";
  };

  propagatedBuildInputs = [
    pyqt5
    qtpy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Requires https://github.com/boylea/qtbot which is unmaintained
  doCheck = false;

  pythonImportsCheck = [ "qtawesome" ];

  meta = with lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    mainProgram = "qta-browser";
    homepage = "https://github.com/spyder-ide/qtawesome";
    changelog = "https://github.com/spyder-ide/qtawesome/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux; # fails on Darwin
  };
}
