{
  lib,
  buildPythonPackage,
  fetchPypi,
  ssdeep,
  pefile,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pyimpfuzzy";
  version = "0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "da9796df302db4b04a197128637f84988f1882f1e08fdd69bbf9fdc6cfbaf349";
  };

  build-system = [ setuptools ];

  buildInputs = [ ssdeep ];

  dependencies = [ pefile ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pyimpfuzzy" ];

  meta = {
    description = "Python module which calculates and compares the impfuzzy (import fuzzy hashing)";
    homepage = "https://github.com/JPCERTCC/impfuzzy";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
