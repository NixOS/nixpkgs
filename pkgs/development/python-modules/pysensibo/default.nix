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
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Otk5W3VTbOAeZOVnXvW8VSxU1nHa8zUvmvduRTdlwVs=";
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
