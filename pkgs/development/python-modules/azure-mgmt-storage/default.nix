{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-storage";
  version = "20.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-IU8/3oyR4n1T8uZUoo0VADrT9vFchDioIF8MiKSNlFE=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.storage"
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer olcai maxwilson ];
  };
}
