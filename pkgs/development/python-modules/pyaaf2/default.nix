{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyaaf2";
  version = "1.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Y5ahLyk6hjBueg4SVji9tKWGVyQGkSPcfgwsiuJwiU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "aaf2" ];

  # The test suite relies on sample .aaf files that are not distributed with
  # the sdist on PyPI.
  doCheck = false;

  meta = {
    description = "Module for reading and writing Advanced Authoring Format (AAF) files";
    homepage = "https://github.com/markreidvfx/pyaaf2";
    changelog = "https://github.com/markreidvfx/pyaaf2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
