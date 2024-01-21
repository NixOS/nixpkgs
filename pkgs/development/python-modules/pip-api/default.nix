{ lib
, buildPythonPackage
, fetchFromGitHub
, pip
, pretend
, pytestCheckHook
, pythonOlder
, setuptools
, virtualenv
}:

buildPythonPackage rec {
  pname = "pip-api";
  version = "0.0.31";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "di";
    repo = "pip-api";
    rev = "refs/tags/${version}";
    hash = "sha256-WFyrEEfrGwsITYzQaukwmz5ml+I6zlMddINTkGeNUTM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pip
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
    virtualenv
  ];

  pythonImportsCheck = [
    "pip_api"
  ];

  disabledTests = [
    "test_hash"
    "test_hash_default_algorithm_is_256"
    "test_installed_distributions"
    "test_invoke_install"
    "test_invoke_uninstall"
    "test_isolation"
  ];

  meta = with lib; {
    description = "Importable pip API";
    homepage = "https://github.com/di/pip-api";
    changelog = "https://github.com/di/pip-api/blob/${version}/CHANGELOG";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
