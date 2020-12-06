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
  version = "3.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d9f2b5ca24bc4c7a390d22323ca4bad200368612b5aaa7796babf971d2b2f18";
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
