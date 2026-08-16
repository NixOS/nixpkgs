{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  azure-common,
  azure-storage-common,
  azure-cosmosdb-nspkg,
  futures ? null,
  isPy3k,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-cosmosdb-table";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XwYdKrjc8vC06WXVl257eusSR+qJaRHw4dKQkqqqKcc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    azure-common
    azure-storage-common
    azure-cosmosdb-nspkg
  ]
  ++ lib.optionals (!isPy3k) [ futures ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
