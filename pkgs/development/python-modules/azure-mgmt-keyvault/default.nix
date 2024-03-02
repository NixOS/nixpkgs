{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-keyvault";
  version = "10.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GDtBZM8YaLjqfv6qmO2tfSpOFKm9l3woGLErdRUM0qI=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-keyvault_${version}/sdk/keyvault/azure-mgmt-keyvault/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer maxwilson ];
  };
}
