{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-applicationinsights";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-qIRbgDZbfyALrR9xqA0NMfO+wB7f1GfftsE+or1xupY=";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Application Insights Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
