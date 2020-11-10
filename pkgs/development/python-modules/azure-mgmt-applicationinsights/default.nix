{ lib
, buildPythonPackage
, python
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-applicationinsights";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3c788a54db4fbca1a8850151462ec1471ff59c86b3a10d6082952bbdaa7e6651";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Application Insights Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
