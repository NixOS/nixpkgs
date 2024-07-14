{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  ply,
  six,
  decorator,
}:

buildPythonPackage rec {
  pname = "jsonpath-rw";
  version = "1.4.0";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BcRxKBxFrhE/YQPRJo7HpIMaLpaqgN5F7cibEfrE++w=";
  };

  propagatedBuildInputs = [
    ply
    six
    decorator
  ];

  # ImportError: No module named tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kennknowles/python-jsonpath-rw";
    description = "Robust and significantly extended implementation of JSONPath for Python, with a clear AST for metaprogramming";
    mainProgram = "jsonpath.py";
    license = licenses.asl20;
  };
}
