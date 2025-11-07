{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-path";
  version = "0.1.3";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "python_path";
    inherit version;
    hash = "sha256-ti2arB2k2u4/A27QiFMs+LaGZtOqEDVn3CK2U5MWyLM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "python_path" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Clean way to import scripts on other folders via a context manager";
    homepage = "https://github.com/cgarciae/python_path";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
