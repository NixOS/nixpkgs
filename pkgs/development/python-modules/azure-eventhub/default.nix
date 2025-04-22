{
  lib,
  azure-core,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "35.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-containerservice_${version}";
    hash = "sha256-hfRBJusZEqea5B8FVlYqLD916jn06bfP3tjD8K8Wfog=";
  };

  sourceRoot = "${src.name}/sdk/eventhub/azure-eventhub";

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${src.tag}/sdk/eventhub/azure-eventhub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
