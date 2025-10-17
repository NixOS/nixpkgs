{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-schluter";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FS6aflpRDoIHsE4XIf93Q6MsO9ApRbU+efm7zWpw/dY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "schluter" ];

  meta = {
    description = "Python API for Schluter DITRA-HEAT thermostat";
    homepage = "https://github.com/prairieapps/py-schluter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
