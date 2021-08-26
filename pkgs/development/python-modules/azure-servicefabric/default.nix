{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "8.0.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f414cc114e28a358a7f39772205f3f15d7fc1aa30a08d106b0b80623f4303f1d";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project provides a client library in Python that makes it easy to consume Microsoft Azure Storage services";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
