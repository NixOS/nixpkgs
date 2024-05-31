{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-extendedlocation";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-jRo6EFP8Dg3i9U8HLfjED9QFfWbdg+X3o9PSf4eus9o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonImportsCheck = [ "azure.mgmt.extendedlocation" ];

  meta = with lib; {
    description = "Microsoft Azure Extendedlocation Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/extendedlocation/azure-mgmt-extendedlocation";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-extendedlocation_${version}/sdk/extendedlocation/azure-mgmt-extendedlocation";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
