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
}:

buildPythonPackage rec {
  pname = "azure-mgmt-postgresqlflexibleservers";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_postgresqlflexibleservers";
    inherit version;
    hash = "sha256-5aSpnUCTol+L1w7XZp6d2QRN+LxGOpUUztiMQqkD55E=";
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
    "azure.mgmt.postgresqlflexibleservers"
  ];

  meta = {
    description = "Microsoft Azure Postgresqlflexibleservers Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-postgresqlflexibleservers/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
