{ lib
, buildPythonPackage
, esprima
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools-scm
, urllib3
}:

buildPythonPackage rec {
  pname = "quantum-gateway";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cisasteelersfan";
    repo = "quantum_gateway";
    rev = version;
    sha256 = "f2LYOr9xJSfbA/1aHfll5lg7r05o855Zkkk9HuRamP8=";
  };

  propagatedBuildInputs = [
    urllib3
    esprima
    requests
  ];

  checkInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "quantum_gateway"
  ];

  meta = with lib; {
    description = "Python library for interacting with Verizon Fios Quantum gateway devices";
    homepage = "https://github.com/cisasteelersfan/quantum_gateway";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
