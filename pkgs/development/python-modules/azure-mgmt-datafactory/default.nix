{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datafactory";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XfTLbVdoPVLKgVlBDr59N0EKe+G9fAS+SjI9cWhhs4g=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.datafactory"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Data Factory Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-datafactory_${version}/sdk/datafactory/azure-mgmt-datafactory";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
