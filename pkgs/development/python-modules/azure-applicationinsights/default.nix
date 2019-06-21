{ lib, buildAzurePythonPackage, fetchPypi
, azure-common
, msrest
}:

buildAzurePythonPackage rec {
  version = "0.1.0";
  pname = "azure-applicationinsights";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0n88zpvyqrrixa2ghz6li91fls6hpnpz9qqyqb9d5zxnkcb3j63f";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Application Insights Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/applicationinsights/azure-applicationinsights";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
