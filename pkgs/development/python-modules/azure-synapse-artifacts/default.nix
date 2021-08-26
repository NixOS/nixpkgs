{ lib, buildPythonPackage, fetchPypi
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3d4fdfd0bd666984f7bdc7bc0c7a6018c35a5d46a81a32dd193b07c03b528b72";
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
