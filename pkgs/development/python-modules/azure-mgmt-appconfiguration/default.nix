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
  pname = "azure-mgmt-appconfiguration";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_appconfiguration";
    inherit version;
    hash = "sha256-x9ItR8hiQrj311Lx3BgojaSsQcL2l0C5fe6AI58PDO4=";
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

  meta = with lib; {
    description = "Microsoft Azure App Configuration Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/appconfiguration/azure-mgmt-appconfiguration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-appconfiguration_${version}/sdk/appconfiguration/azure-mgmt-appconfiguration/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
