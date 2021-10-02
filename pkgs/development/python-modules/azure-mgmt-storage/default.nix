{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  version = "19.0.0";
  pname = "azure-mgmt-storage";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f05963e5a8696d0fd4dcadda4feecb9b382a380d2e461b3647704ac787d79876";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.storage" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer olcai maxwilson ];
  };
}
