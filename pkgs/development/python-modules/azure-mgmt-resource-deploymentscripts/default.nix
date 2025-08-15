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
  pname = "azure-mgmt-resource-deploymentscripts";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deploymentscripts";
    inherit version;
    hash = "sha256-Vm2FWVPpSbsrNMtD4ecwVKqnkoHHRhO3Rf/duCyAI3U=";
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
    "azure.mgmt.resource.deploymentscripts"
  ];

  meta = {
    description = "Microsoft Azure Resource Deploymentscripts Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-resource-deploymentscripts/";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
