{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonAtLeast,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "pynetio";
  version = "0.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SSe6OHubWszOTnwytL/3GhzD4lGIz9kxS75kuJv7vKA=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynetio" ];

  meta = {
    description = "Binding library for Koukaam netio devices";
    homepage = "https://github.com/wookiesh/pynetio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
