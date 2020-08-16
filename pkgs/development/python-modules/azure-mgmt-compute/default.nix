{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:

buildPythonPackage rec {
  version = "13.0.0";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7f331bafcbedf25d65aa42038f7553747dab18d7f10a5af3297192d31c45339e";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
