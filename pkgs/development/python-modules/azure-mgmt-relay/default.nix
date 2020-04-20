{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-relay";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0s5z4cil750wn770m0hdzcrpshj4bj1bglkkvxdx9l9054dk9s57";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Relay Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
