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
  pname = "azure-mgmt-resource-templatespecs";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_templatespecs";
    inherit version;
    hash = "sha256-D55zmrQ9sq2HDq5d8bXEv6BQC76hxuWKpeLpw4X6y8U=";
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
    "azure.mgmt.resource.templatespecs"
  ];

  meta = {
    description = "Microsoft Azure Resource Templatespecs Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-resource-templatespecs/";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
