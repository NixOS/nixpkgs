{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, azure-common
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "azure-loganalytics";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3ceb350def677a351f34b0a0d1637df6be0c6fe87ff32a5270b17f540f6da06e";
  };

  propagatedBuildInputs = [
    msrest
    azure-common
  ];

  pythonNamespaces = [ "azure" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
