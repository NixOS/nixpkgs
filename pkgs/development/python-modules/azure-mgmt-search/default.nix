{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-search";
  version = "9.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Gc+qoTa1EE4/YmJvUSqVG+zZ50wfohvWOe/fLJ/vgb0=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.search"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Search Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
