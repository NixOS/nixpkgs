{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.22";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SRyL6cBA9TkPW/RKWwd1K9B/Vu35kjgbBccBQ57sEPY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];
  disabled = pythonOlder "3.8";

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
