{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-sql";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8399702e9d1836f3b040ce0c93d8dc089767d66edb9224a3b8a6c9ab7e8ff01f";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure SQL Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/sql?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
