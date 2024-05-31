{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-core,
  cryptography,
  msal,
  msal-extensions,
}:

buildPythonPackage rec {
  pname = "azure-identity";
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b/HWZ83Ngdoc6rQvgKC+Y8qEZin1GKki9zF6fjyEThs=";
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    msal
    msal-extensions
  ];

  pythonImportsCheck = [ "azure.identity" ];

  # Requires checkout from mono-repo and a mock account:
  # https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/identity/tests.yml
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Identity Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-identity_${version}/sdk/identity/azure-identity/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
