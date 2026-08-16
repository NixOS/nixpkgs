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
  pname = "azure-mgmt-redhatopenshift";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_redhatopenshift";
    inherit version;
    hash = "sha256-R3XJvfNjI4g02hReX1n5doOrBPjdvSUN5F1F4zeYMn8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = "azure.mgmt";

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.redhatopenshift" ];

  meta = {
    description = "Microsoft Azure Red Hat Openshift Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
