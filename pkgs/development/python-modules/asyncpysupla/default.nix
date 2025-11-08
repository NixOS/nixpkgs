{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncpysupla";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sRw4qAkHPIIc27FtxIe2vOvSK9PPBJYOZzDLgGYapDc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Tests require API credentials and network access
  doCheck = false;

  pythonImportsCheck = [ "asyncpysupla" ];

  meta = {
    description = "Simple Supla's OpenAPI async wrapper";
    homepage = "https://github.com/mwegrzynek/asyncpysupla";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
