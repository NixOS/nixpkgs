{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-nspkg,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-cosmosdb-nspkg";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rPaR5pKBjZplxlPHo0heuONcC9xJa7plLl6jkFugnNg=";
  };

  build-system = [ setuptools ];

  dependencies = [ azure-nspkg ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure CosmosDB namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
