{
  lib,
  buildPythonPackage,
  setuptools,
  cffi,
  cryptography,
  importlib-metadata,
  requests,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "keeper_secrets_manager_core";
  version = "17.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+CHRFLROzZkocPRmHR2qXFCQHUq8xtUsN5JsNyOW0xw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cffi
    cryptography
    importlib-metadata
    requests
  ];

  pythonImportsCheck = [
    "keeper_secrets_manager_core"
  ];

  meta = {
    description = "Keeper Secrets Manager Python SDK";
    homepage = "https://pypi.org/project/keeper-secrets-manager-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
