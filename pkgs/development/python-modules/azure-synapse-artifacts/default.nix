{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5e1d8f03939eafe29c301659c7b819053513be6f224861388b0048ca62e7a75d";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  # zero tests run
  doCheck = false;

  pythonImportsCheck = [ "azure.synapse.artifacts" ];

  meta = with lib; {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
