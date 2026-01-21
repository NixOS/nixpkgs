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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_postgresqlflexibleservers";
    inherit version;
    hash = "sha256-E9L0W6IYo2T7BAVoT4Bw8mGuPtWX1aVNBOMphzLEzao=";
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
    maintainers = [ ];
  };
}
