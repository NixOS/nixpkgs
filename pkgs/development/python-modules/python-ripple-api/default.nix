{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ripple-api";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hlgc7swcCimpQueyxuy/zvr6WdBHWnjnqHTS/cUghss=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # No tests in the package
  doCheck = false;

  pythonImportsCheck = [ "pyripple" ];

  meta = {
    description = "Python API for interacting with ripple.com";
    homepage = "https://github.com/nkgilley/python-ripple-api";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
