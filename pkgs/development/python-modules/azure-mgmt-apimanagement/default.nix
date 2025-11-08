{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-apimanagement";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_apimanagement";
    inherit version;
    hash = "sha256-Crf+F+cP4xVM2ED/R9GdekYQIXAD6qfCGs81EableZk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.apimanagement"
  ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/apimanagement/azure-mgmt-apimanagement";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-apimanagement_${version}/sdk/apimanagement/azure-mgmt-apimanagement/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
