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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    rev = "35d760ceb64ec318f302a6e4d3a4a80feda97a9e";
    sha256 = "sha256-CXD8MhsdWYAcG5WDVTT/A2HDtiO1xfQbrwlYVnxXpBU=";
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
