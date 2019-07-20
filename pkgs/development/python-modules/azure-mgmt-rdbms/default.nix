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
  pname = "azure-mgmt-rdbms";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "40abbe4f9c59d7906594ceed067d0e7d09fef44be0d16aded5d5717f1a8aa5ea";
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
    description = "This is the Microsoft Azure RDBMS Management Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-rdbms;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
