{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-common,
  azure-mgmt-core,
  isodate,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource-deployments";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deployments";
    inherit version;
    hash = "sha256-c1m0JliCbn5/8T5tuwxJDpX8yV28oiTSuFz3GtdTXx0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.deployments"
    "azure.mgmt.resource.deployments.models"
  ];

  meta = {
    description = "Microsoft Azure Resource Deployments Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-resource-deployments/";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
