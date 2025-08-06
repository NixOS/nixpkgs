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
  pname = "azure-mgmt-resource-deploymentstacks";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deploymentstacks";
    inherit version;
    hash = "sha256-Sbh25FwPW6uI7EfXxW6Ps0+9/P5bgxo6KiHoF/PZcy4=";
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
    "azure.mgmt.resource.deploymentstacks"
  ];

  meta = {
    description = "Microsoft Azure Resource Deploymentstacks Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-resource-deploymentstacks/";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
