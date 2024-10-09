{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-core,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xWEnPkQCwlEUhzSGyYv6GyxHiGIp1BAOh9rxAO4Edyg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.keyvault.certificates" ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Certificates Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-certificates";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-keyvault-certificates_${version}/sdk/keyvault/azure-keyvault-certificates/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
