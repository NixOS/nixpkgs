{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-933etYrKRgSqJfOMIuIDL4Uv4/RdSEFMNWFtW5qiPpA=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "dyn" ];

  meta = {
    description = "Dynect dns lib";
    homepage = "https://dyn.readthedocs.org";
    changelog = "https://github.com/dyninc/dyn-python/blob/${version}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
