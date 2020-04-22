{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, isPy3k
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-advisor";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1ecea7a9dc48c099c06aab68aace7fdbded91a5522932882b1707c29fa055054";
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
    description = "This is the Microsoft Azure Advisor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
