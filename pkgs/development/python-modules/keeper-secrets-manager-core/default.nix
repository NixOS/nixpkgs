{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  cffi,
  cryptography,
  importlib-metadata,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keeper-secrets-manager-core";
  version = "17.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Keeper-Security";
    repo = "secrets-manager";
    rev = "release/sdk/python/core/v${version}";
    hash = "sha256-kYEZOI3ucpLHjWHjvCit/NOJyBjzQ6PEtvAk3Z+NDlg=";
  };

  sourceRoot = "${src.name}/sdk/python/core";
  build-system = [
    setuptools
  ];

  dependencies = [
    cffi
    cryptography
    importlib-metadata
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = true;
  pythonImportsCheck = [
    "keeper_secrets_manager_core"
  ];

  meta = {
    description = "Keeper Secrets Manager Python SDK";
    homepage = "https://github.com/Keeper-Security/secrets-manager/tree/master/sdk/python/core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
