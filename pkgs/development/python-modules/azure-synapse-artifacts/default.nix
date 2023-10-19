{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, azure-mgmt-core
, msrest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-58k8F/aUBBNJwGBiPZojkSzEXZ3Kd6uEwr0cZbFaM9k=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-mgmt-core
    msrest
  ];

  # zero tests run
  doCheck = false;

  pythonImportsCheck = [
    "azure.synapse.artifacts"
  ];

  meta = with lib; {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
