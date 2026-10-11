{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "hko";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6FzdaSaw7sX52wM8HbHFGtKdR2JBg3B2cMZnP7RfQzs=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "hko" ];

  meta = {
    description = "Unofficial Python wrapper for the Hong Kong Observatory public API";
    homepage = "https://github.com/MisterCommand/python-hko";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
