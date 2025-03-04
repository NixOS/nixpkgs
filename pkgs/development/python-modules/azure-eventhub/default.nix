{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_eventhub";
    inherit version;
    hash = "sha256-UTCICIQQGpalfLfFs3xksECYd0KdVMDVcDeLTwt7bTU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-core
    typing-extensions
  ];

  # too complicated to set up
  doCheck = false;

  pythonImportsCheck = [
    "azure.eventhub"
    "azure.eventhub.aio"
  ];

  meta = with lib; {
    description = "Microsoft Azure Event Hubs Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/eventhub/azure-eventhub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-eventhub_${version}/sdk/eventhub/azure-eventhub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
