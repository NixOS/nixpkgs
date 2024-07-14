{
  buildPythonPackage,
  lib,
  fetchPypi,
  six,
  requests,
}:

buildPythonPackage rec {
  version = "2.3.5";
  format = "setuptools";
  pname = "pydocumentdb";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hm8HKuUW/AYclEL4ykcEY7U9xibw9qhv86gDKT9LUN0=";
  };

  # https://github.com/Azure/azure-cosmos-python/issues/183
  preBuild = ''
    touch changelog.md
  '';

  propagatedBuildInputs = [
    six
    requests
  ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-cosmos-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
