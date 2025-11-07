{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "namex";
  version = "0.1.0";
  pyproject = true;

  # Not using fetchFromGitHub because the repo does not have any tag/release
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EX8DzNMCzEjj9cWKKWg49ricg0VauGg6HoXypDCqQwY=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "namex" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Simple utility to separate the implementation of your Python package and its public API surface";
    homepage = "https://github.com/fchollet/namex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
