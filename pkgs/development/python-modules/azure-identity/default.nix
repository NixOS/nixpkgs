{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-core,
  cryptography,
  msal,
  msal-extensions,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.23.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_identity";
    inherit version;
    hash = "sha256-Imwe+YKp+NXc9uD57TXq7ypNlx592GMX6bnVLnCgNeQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    cryptography
    msal
    msal-extensions
    typing-extensions
  ];

  pythonImportsCheck = [ "azure.identity" ];

  # Requires checkout from mono-repo and a mock account:
  # https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/identity/tests.yml
  doCheck = false;

  meta = {
    description = "Microsoft Azure Identity Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/identity/azure-identity";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-identity_${version}/sdk/identity/azure-identity/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
