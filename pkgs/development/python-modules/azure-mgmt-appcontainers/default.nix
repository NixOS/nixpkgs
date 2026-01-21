{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-appcontainers";
  version = "4.0.0";
  format = "setuptools";
  pyroject = true;

  src = fetchPypi {
    pname = "azure_mgmt_appcontainers";
    inherit version;
    hash = "sha256-FzETbKAWbF+8IaWM036nZ4fSCYnn+V3BKuYn768dw6U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
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
