{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
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
  version = "2.19";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy";
    rev = "v${version}";
    hash = "sha256-oSWq/D1EX6mxUDElfujyOSEtql0csAm72u2B5RuQddE=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    quantiphy-eval
    rkm-codes
  ];

  nativeCheckInputs = [
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
