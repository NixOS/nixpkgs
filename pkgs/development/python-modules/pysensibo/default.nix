{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yITcVEBtqH1B+MyhQweOzmdgPgWrueAkczp/UsT4J/4=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pysensibo" ];

  meta = with lib; {
    description = "Module for interacting with Sensibo";
    homepage = "https://github.com/andrey-git/pysensibo";
    changelog = "https://github.com/andrey-git/pysensibo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
