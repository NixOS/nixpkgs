{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-databoxedge";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_databoxedge";
    inherit version;
    hash = "sha256-8Y8GbQJ8maIkmY08R0CBJoIVmr44z1joewl3DKssrMA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # no tests in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.databoxedge" ];

  meta = with lib; {
    description = "Microsoft Azure Databoxedge Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/databox/azure-mgmt-databox";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-databoxedge_${version}/sdk/databox/azure-mgmt-databox/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
