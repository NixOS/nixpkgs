{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-iothub";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "azure_mgmt_iothub";
    inherit version;
    hash = "sha256-B/Jb1vZzdLqxfMEZL5+SGzUONWAlHxkGnmZlg1Qe1Ng=";
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

  meta = with lib; {
    description = "This is the Microsoft Azure IoTHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/iothub/azure-mgmt-iothub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-iothub_${version}/sdk/iothub/azure-mgmt-iothub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
