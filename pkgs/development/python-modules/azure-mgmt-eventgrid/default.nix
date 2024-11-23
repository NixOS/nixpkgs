{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-eventgrid";
  version = "10.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-jJ+gvJmOTz2YXQ9BDrFgXCybplgwvOYZ5Gv7FHLhxQA=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-mgmt-core
    azure-common
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.eventgrid" ];

  meta = with lib; {
    description = "This is the Microsoft Azure EventGrid Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
