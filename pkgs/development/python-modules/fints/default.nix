{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pythonRelaxDepsHook
, setuptools
, bleach
, mt-940
, enum-tools
, requests
, sepaxml
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "fints";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    hash = "sha256-1k6ZeYlv0vxNkqQse9vi/NT6ag3DJONKCWB594LvER0=";
  };

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "enum-tools"
  ];

  dependencies = [
    bleach
    enum-tools
    mt-940
    requests
    sepaxml
  ];

  pythonImportsCheck = [ "fints" ];

  nativeCheckInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ elohmeier dotlambda ];
  };
}
