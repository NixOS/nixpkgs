{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-monitor";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-rwUhKm9arvUW3EWAgv3+SdJYR54Hob2RmMDA6IjEpn4=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
