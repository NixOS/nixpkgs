{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ppdeep";
  version = "20251115";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xv21EXsO6/vpGhF7PIn03l0WGnoMGi0wI6BlpnZye3w=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ppdeep" ];

  meta = with lib; {
    description = "Python library for computing fuzzy hashes (ssdeep)";
    homepage = "https://github.com/elceef/ppdeep";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
