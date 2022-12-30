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
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zXwIwYG76aCKPTE8mGiAOK8kQUCzJbqnjJszmIqByaA=";
  };

  propagatedBuildInputs = [
    pyqt5
    qtpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Requires https://github.com/boylea/qtbot which is unmaintained
  doCheck = false;

  pythonImportsCheck = [
    "qtawesome"
  ];

  meta = with lib; {
    description = "Iconic fonts in PyQt and PySide applications";
    homepage = "https://github.com/spyder-ide/qtawesome";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # fails on Darwin
  };
}
