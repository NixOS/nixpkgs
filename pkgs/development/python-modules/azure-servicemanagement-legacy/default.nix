{ buildAzurePythonPackage
, fetchPypi
, lib
, isPy3k
, python
, azure-common
, requests
}:

buildAzurePythonPackage rec {
  version = "0.20.6";
  pname = "azure-servicemanagement-legacy";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "07cq21f9xa7fg8irdmggllmcmzm9j9ywps24jdxwpx6llf7zz0y8";
  };

  propagatedBuildInputs = [
    azure-common
    requests
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai jonringer mwilsoninsight ];
  };
}
