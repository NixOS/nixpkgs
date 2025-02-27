{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "logfire-api";
  version = "3.6.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "logfire";
    tag = "v${version}";
    hash = "sha256-otU1ncpg1HYYh/tnrqAdqoETirGJM7BV8HsH9CYxrnU=";
  };

  sourceRoot = "source/logfire-api";

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "logfire_api"
  ];

  meta = {
    description = "Shim for the Logfire SDK which does nothing unless Logfire is installed";
    homepage = "https://pypi.org/project/logfire-api/";
    changelog = "https://github.com/pydantic/logfire/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yomaq ];
  };
}
