{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycparser";
  version = "2.22";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SRyL6cBA9TkPW/RKWwd1K9B/Vu35kjgbBccBQ57sEPY=";
  };

  nativeCheckInputs = [ unittestCheckHook ];
  disabled = pythonOlder "3.8";

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  meta = with lib; {
    description = "C parser in Python";
    homepage = "https://github.com/eliben/pycparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
