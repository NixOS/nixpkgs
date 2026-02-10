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
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_appcontainers";
    inherit version;
    hash = "sha256-bp7WPCwssPZD+tZ52BMIxKomFWztQfwDPl9MBJghjz4=";
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
