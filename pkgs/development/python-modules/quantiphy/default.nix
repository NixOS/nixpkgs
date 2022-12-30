{ lib
, buildPythonPackage
, fetchFromGitHub
, flitBuildHook
, pytestCheckHook
, pythonOlder
, inform
, parametrize-from-file
, setuptools
, voluptuous
, quantiphy-eval
, rkm-codes
}:

buildPythonPackage rec {
  pname = "quantiphy";
  version = "2.18";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy";
    rev = "v${version}";
    hash = "sha256-KXZQTal5EQDrMNV9QKeuLeYYDaMfAJlEDEagq2XG9/Q=";
  };

  nativeBuildInputs = [
    flitBuildHook
  ];

  propagatedBuildInputs = [
    quantiphy-eval
    rkm-codes
  ];

  checkInputs = [
    inform
    parametrize-from-file
    pytestCheckHook
    setuptools
    voluptuous
  ];

  pythonImportsCheck = [
    "quantiphy"
  ];

  meta = with lib; {
    description = "Module for physical quantities (numbers with units)";
    homepage = "https://quantiphy.readthedocs.io";
    changelog = "https://github.com/KenKundert/quantiphy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
