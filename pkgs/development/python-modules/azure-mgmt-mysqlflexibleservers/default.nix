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
  pname = "azure-mgmt-mysqlflexibleservers";
  version = "1.0.0b2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_mysqlflexibleservers";
    inherit version;
    hash = "sha256-pL3z3s/H7OYaPiGNGdUIzo3ppp6sR/G+6iDB219Mp9A=";
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
    "azure.mgmt.mysqlflexibleservers"
  ];

  meta = {
    description = "Microsoft Azure Mysqlflexibleservers Management Client Library for Python";
    homepage = "https://pypi.org/project/azure-mgmt-mysqlflexibleservers/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
