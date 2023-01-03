{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt5
}:

buildPythonPackage rec {
  pname = "anyqt";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ales-erjavec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dL2EUAMzWKq/oN3rXiEC6emDJddmg4KclT5ONKA0jfk=";
  };

  doCheck = false;

  checkInputs = [ pyqt5 ];

  pythonImportsCheck = [ "AnyQt" ];

  meta = with lib; {
    description = "A PyQt/PySide compatibility layer";
    homepage = "https://anyqt.readthedocs.io";
    changelog = "https://github.com/ales-erjavec/anyqt/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
