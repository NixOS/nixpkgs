{ lib, buildPythonPackage, isPy3k, python
, antlr4
}:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;
  disabled = !isPy3k;

  sourceRoot = "source/runtime/Python3";

  checkPhase = ''
    cd test
    ${python.interpreter} ctest.py
  '';

  meta = with lib; {
    description = "Runtime for ANTLR";
    homepage = "https://www.antlr.org/";
    license = licenses.bsd3;
  };
}
