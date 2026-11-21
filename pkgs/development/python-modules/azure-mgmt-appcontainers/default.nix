{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  msrest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-appcontainers";
  version = "5.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_appcontainers";
    inherit version;
    hash = "sha256-0hiEOkknHMSkcJS9VD1JE3Hf2SVElqZ6NzWSJ2MeU8I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    msrest
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.appcontainers" ];

  meta = {
    description = "Microsoft Azure Appcontainers Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/appcontainers/azure-mgmt-appcontainers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
