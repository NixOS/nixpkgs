{ lib
, buildPythonPackage
, fetchFromGitHub
, execnet
, glob2
, Mako
, mock
, parse
, parse-type
, py
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = version;
    sha256 = "sha256-3P9ongMAsLITOCRPmME492xnkdVc8IdOVrINK57gfOY=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    glob2
    Mako
    parse
    parse-type
    py
  ];

  checkInputs = [
    pytestCheckHook
    execnet
    mock
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "pytest_bdd"
  ];

  meta = with lib; {
    description = "BDD library for the pytest";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
