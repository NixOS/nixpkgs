{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-iothub";
  version = "5.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_iothub";
    inherit version;
    hash = "sha256-WPLCSTjBlbMsBaKaOKw64WH01Le6aI4Pd1JfooXKJds=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.iothub" ];

  meta = {
    description = "This is the Microsoft Azure IoTHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/iothub/azure-mgmt-iothub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-iothub_${version}/sdk/iothub/azure-mgmt-iothub/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
