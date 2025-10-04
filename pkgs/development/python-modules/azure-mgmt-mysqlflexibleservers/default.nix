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
  version = "1.0.0b3";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_mysqlflexibleservers";
    inherit version;
    hash = "sha256-YR/Yjz2x4KhHehYz/pTEYdFyE+IVFw61PB7qm4I71MM=";
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
