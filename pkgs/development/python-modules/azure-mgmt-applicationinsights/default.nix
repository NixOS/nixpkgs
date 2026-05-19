{
  lib,
  buildPythonPackage,
  fetchPypi,
  isodate,
  azure-common,
  azure-mgmt-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-applicationinsights";
  version = "4.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_applicationinsights";
    inherit version;
    hash = "sha256-FVMTkPEs49dnzT8ZSa82qjkHfBRclS/sTYAwPIbse2w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Application Insights Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/applicationinsights/azure-mgmt-applicationinsights";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-applicationinsights_${version}/sdk/applicationinsights/azure-mgmt-applicationinsights/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
