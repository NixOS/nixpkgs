{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-mgmt-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-mysqlflexibleservers";
  version = "1.1.0b2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_mysqlflexibleservers";
    inherit version;
    hash = "sha256-yGpEFn9VOP1uSvpUCV/gYW56/5HulsCVx9wc/kWO+Ro=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
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
    maintainers = [ ];
  };
}
