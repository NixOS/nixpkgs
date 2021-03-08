{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-search";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a96d50c88507233a293e757202deead980c67808f432b8e897c4df1ca088da7e";
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
  pythonImportsCheck = [ "azure.mgmt.search" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Search Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
