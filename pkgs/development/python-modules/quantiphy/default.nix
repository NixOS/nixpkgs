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
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy";
    rev = "v${version}";
    sha256 = "sha256-KXZQTal5EQDrMNV9QKeuLeYYDaMfAJlEDEagq2XG9/Q=";
  };

  format = "pyproject";
  nativeBuildInputs = [
    flitBuildHook
  ];
  checkInputs = [
    inform
    parametrize-from-file
    pytestCheckHook
    setuptools
    voluptuous
  ];
  propagatedBuildInputs = [
    quantiphy-eval
    rkm-codes
  ];

  meta = with lib; {
    description = "Module for physical quantities (numbers with units)";
    homepage = "https://quantiphy.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
