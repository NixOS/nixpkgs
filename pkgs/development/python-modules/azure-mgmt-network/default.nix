{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-common
, azure-mgmt-core
, msrest
, msrestazure
, isPy3k
}:

buildPythonPackage rec {
  version = "17.0.0";
  pname = "azure-mgmt-network";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3694f2675e152afccb1588a6cc7bb4b4795d442a4e5d7082cdf1f4e32a779199";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.network" ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
