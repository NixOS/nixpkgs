{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "clearpasspy";
  version = "1.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HAi9z7DT5g0Pkr+rASUK18/tEsorWXScCODE95Q+ZZ0=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "requests" ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "clearpasspy" ];

  meta = {
    description = "ClearPass API Python Library";
    homepage = "https://github.com/zemerick1/clearpasspy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
