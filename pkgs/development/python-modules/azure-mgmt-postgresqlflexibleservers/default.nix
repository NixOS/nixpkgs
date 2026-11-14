{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-common,
  azure-mgmt-core,
  isodate,
  msrest,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-postgresqlflexibleservers";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_postgresqlflexibleservers";
    inherit version;
    hash = "sha256-U9tpQlPhB3xBknvK6WYuTn4E8EWA3e67w3mZ2/LyjdY=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    msrest
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.mgmt.postgresqlflexibleservers"
  ];

  meta = {
    description = "Microsoft Azure Postgresqlflexibleservers Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-postgresqlflexibleservers/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
