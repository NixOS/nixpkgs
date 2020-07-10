{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "7.1.0.45";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8dd0eb419ca62f2436c31982f6d236868f15f65bb062c4e5a98e50b16298dcda";
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
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
