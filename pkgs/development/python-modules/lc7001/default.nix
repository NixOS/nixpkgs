{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lc7001";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I4I3vwW1kJsgLFPMGpe9hkD3iEeC3AqI4pCi6SCWPx4=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [ cryptography ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "lc7001" ];

  meta = {
    description = "Python module for interacting with Legrand LC7001";
    homepage = "https://github.com/rtyle/lc7001";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
