{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-rdbms";
  version = "10.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "bdc479b3bbcac423943d63e746a81dd5fc80b46a4dbb4393e760016e3fa4f74a";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.rdbms" ];

  meta = with lib; {
    description = "This is the Microsoft Azure RDBMS Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
