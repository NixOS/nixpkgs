{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-core,
  cryptography,
  msal,
  msal-extensions,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_identity";
    inherit version;
    hash = "sha256-9WdXmmXYky+pE8du3fMwUQGhXlcnpeSqXfZJoPVT1MM=";
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

  meta = with lib; {
    description = "Microsoft Azure Identity Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/identity/azure-identity";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-identity_${version}/sdk/identity/azure-identity/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
