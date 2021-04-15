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
  version = "3.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49";
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
