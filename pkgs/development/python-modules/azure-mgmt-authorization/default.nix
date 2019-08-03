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
  pname = "azure-mgmt-authorization";
  version = "0.51.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d2789e21c6b85591b38d5d4e9b835b6546824c14e14aaa366da0ef50a95d2478";
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
    description = "This is the Microsoft Azure Authorization Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-authorization;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
