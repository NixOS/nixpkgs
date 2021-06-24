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
  version = "18.0.0";
  pname = "azure-mgmt-network";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "85fdeb7a1a8d89be9b585396796b218b31b681590d57d82d3ea14cf1f2d20b4a";
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
