{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "6.4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f049e8c4a179f1277f2ec60158f88caf14a50f7df491fc6841e360cd61746da1";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project provides a client library in Python that makes it easy to consume Microsoft Azure Storage services";
    homepage = https://pypi.org/project/azure-servicefabric;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
