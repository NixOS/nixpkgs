{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  msrest,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-eventgrid";
  version = "10.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_eventgrid";
    inherit version;
    hash = "sha256-MD5eJ89LteyDO6Tlqe9wtbxBDhkEEuxHzeWdguQT+34=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    msrest
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.eventgrid" ];

  meta = with lib; {
    description = "This is the Microsoft Azure EventGrid Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventgrid/azure-mgmt-eventgrid";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-eventgrid_${version}/sdk/eventgrid/azure-mgmt-eventgrid/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
