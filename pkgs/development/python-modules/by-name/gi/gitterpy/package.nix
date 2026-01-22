{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "gitterpy";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nmZ6sVjrHRLfvXMr/fYiN+a4Wly87YKwAR+heP/sNkE=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "gitterpy" ];

  meta = {
    description = "Python interface for the Gitter API";
    homepage = "https://github.com/MichaelYusko/GitterPy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
