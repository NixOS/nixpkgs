{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-mgmt-common,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource";
  version = "23.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "azure_mgmt_resource";
    inherit version;
    hash = "sha256-dHt1DfevI6sw5T0/NiR6sMFt4eJn1maxpQd8OaQpJSk=";
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

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource_${version}/sdk/resources/azure-mgmt-resource/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
