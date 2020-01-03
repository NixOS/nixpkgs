{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "6.5.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "02q32rc3vmg3kpi92s2y2ic47s3mi9qjcvzvrpjdlzji8lhd9w45";
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
