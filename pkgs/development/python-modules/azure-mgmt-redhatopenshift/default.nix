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
  pname = "azure-mgmt-redhatopenshift";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "azure_mgmt_redhatopenshift";
    inherit version;
    hash = "sha256-nTBKy7p8n0JWEmn3ByEKranHteoJkPJyLfYFmaCOOq4=";
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

  meta = with lib; {
    description = "Microsoft Azure Red Hat Openshift Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
