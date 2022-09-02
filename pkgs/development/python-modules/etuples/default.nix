{ lib
, buildPythonPackage
, fetchFromGitHub
, cons
, multipledispatch
, pytestCheckHook
, pytest-html
}:

buildPythonPackage rec {
  pname = "etuples";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    rev = "v${version}";
    sha256 = "sha256-gJNxrO2d/eF4t3bBlz/BwF+9eT1nKrVrTP3F6/dEN00=";
  };

  propagatedBuildInputs = [
    cons
    multipledispatch
  ];

  checkInputs = [
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "etuples" ];

  meta = with lib; {
    description = "Python S-expression emulation using tuple-like objects";
    homepage = "https://github.com/pythological/etuples";
    changelog = "https://github.com/pythological/etuples/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ Etjean ];
  };
}
