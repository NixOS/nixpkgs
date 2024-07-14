{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-cosmosdb-nspkg";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rPaR5pKBjZplxlPHo0heuONcC9xJa7plLl6jkFugnNg=";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure CosmosDB namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
