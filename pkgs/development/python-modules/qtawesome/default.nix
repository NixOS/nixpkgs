{ lib
, buildPythonPackage
, fetchFromGitHub
, pyqt5
, pytestCheckHook
, pythonOlder
, qtpy
}:

buildPythonPackage rec {
  pname = "qtawesome";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dF77vkrEl671fQvsHAX+JY9OmLA29kgAVswY2b3UyTg=";
  };

  propagatedBuildInputs = [
    pyqt5
    qtpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Requires https://github.com/boylea/qtbot which is unmaintained
  doCheck = false;

  pythonImportsCheck = [
    "qtawesome"
  ];

  meta = with lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    mainProgram = "qta-browser";
    homepage = "https://github.com/spyder-ide/qtawesome";
    changelog = "https://github.com/spyder-ide/qtawesome/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # fails on Darwin
  };
}
