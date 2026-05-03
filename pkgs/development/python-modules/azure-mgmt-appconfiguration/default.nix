{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-appconfiguration";
  version = "6.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_appconfiguration";
    inherit version;
    hash = "sha256-zBaEyScWadchaKV5fhg1EmVWa/oSPre/gY3h1vNa5d4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.appconfiguration"
  ];

  meta = {
    description = "Microsoft Azure App Configuration Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/appconfiguration/azure-mgmt-appconfiguration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-appconfiguration_${version}/sdk/appconfiguration/azure-mgmt-appconfiguration/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
