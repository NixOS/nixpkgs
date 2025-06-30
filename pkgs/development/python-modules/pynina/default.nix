{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynina";
  version = "0.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w5iJXmOd0fqWIZnVG6zDop1t2h4B+4v0/EuwgS00LkA=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynina" ];

  meta = with lib; {
    description = "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
    changelog = "https://gitlab.com/DeerMaximum/pynina/-/releases/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
