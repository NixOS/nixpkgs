{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-J96cBqCCajK34M7v+2h6t2ptm7QwmfQt25674Q4Nr94=";
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
