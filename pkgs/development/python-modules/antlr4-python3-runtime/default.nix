{ lib
, buildPythonPackage
, isPy3k
, python
, antlr4 }:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;
  disabled = python.pythonOlder "3.6";

  sourceRoot = "source/runtime/Python3";

  # in 4.9, test was renamed to tests
  checkPhase = ''
    cd test*
    ${python.interpreter} run.py
  '';

  meta = with lib; {
    description = "Runtime for ANTLR";
    homepage = "https://www.antlr.org/";
    license = licenses.bsd3;
  };
}
