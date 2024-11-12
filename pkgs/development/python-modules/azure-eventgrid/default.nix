{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
  version = "4.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-we2rkHabxOei+wogN88EVXVNUK95NnTAiz/sIpMkjEw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    isodate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.eventgrid" ];

  meta = with lib; {
    description = "Fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventgrid/azure-eventgrid";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-eventgrid_${version}/sdk/eventgrid/azure-eventgrid/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
