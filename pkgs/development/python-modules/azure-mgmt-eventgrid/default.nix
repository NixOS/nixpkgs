{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  msrest,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-eventgrid";
  version = "10.4.0";
  pyproject = true;

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

  meta = {
    description = "This is the Microsoft Azure EventGrid Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventgrid/azure-mgmt-eventgrid";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-eventgrid_${version}/sdk/eventgrid/azure-mgmt-eventgrid/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
