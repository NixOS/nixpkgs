{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-mgmt-common,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource";
  version = "24.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource";
    inherit version;
    hash = "sha256-z2uJlfzdQHrJ/x3UdAhxKUKaHZDbsax3+XwZuWI3smU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.resource" ];

  meta = {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource_${version}/sdk/resources/azure-mgmt-resource/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      olcai
      maxwilson
    ];
  };
}
