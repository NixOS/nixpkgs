{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-common,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource-templatespecs";
  version = "1.0.0b1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_resource_templatespecs";
    inherit version;
    hash = "sha256-D55zmrQ9sq2HDq5d8bXEv6BQC76hxuWKpeLpw4X6y8U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt.resource.templatespecs"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.templatespecs"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-templatespecs";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-templatespecs_${version}/sdk/resources/azure-mgmt-resource-templatespecs/CHANGELOG.md";
    license = licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
