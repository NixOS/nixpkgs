{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Otk5W3VTbOAeZOVnXvW8VSxU1nHa8zUvmvduRTdlwVs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pysensibo" ];

  meta = {
    description = "Module for interacting with Sensibo";
    homepage = "https://github.com/andrey-git/pysensibo";
    changelog = "https://github.com/andrey-git/pysensibo/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
