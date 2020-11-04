{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "7.2.0.46";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c15fd5e8fe33a12295435f16e007edcfd8f660547795742f9b74ef8fb3a431ba";
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
