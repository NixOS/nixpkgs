{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "nsw-fuel-api-client";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = "nsw-fuel-api-client";
    tag = version;
    hash = "sha256-3nkBDLmFOfYLvG5fi2subA9zxb51c7zWlhT4GaCQo9I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "nsw_fuel"
  ];

  pytestFlags = [
    "nsw_fuel_tests/unit.py"
  ];

  meta = {
    description = "API Client for NSW Government Fuel Check application";
    homepage = "https://github.com/nickw444/nsw-fuel-api-client";
    changelog = "https://github.com/nickw444/nsw-fuel-api-client/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
