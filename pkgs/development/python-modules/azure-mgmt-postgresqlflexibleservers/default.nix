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
  version = "1.1.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_postgresqlflexibleservers";
    inherit version;
    hash = "sha256-X/AkFBzTsgNO4SU8K9h1w8QAoxOoZfnvvoTyVbwE3K0=";
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
