{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, nose
, pyyaml
, pythonOlder
, importlib-metadata
, isPy3k
}:

buildPythonPackage rec {
  pname = "Markdown";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fafe3f1ecabfb514a5285fca634a53c1b32a81cb0feb154264d55bf2ff22c17";
  };

  propagatedBuildInputs = [ 
    setuptools 
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  disabled = !isPy3k;

  checkInputs = [ nose pyyaml ];

  meta = {
    description = "A Python implementation of John Gruber's Markdown with Extension support";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = lib.licenses.bsd3;
  };
}
