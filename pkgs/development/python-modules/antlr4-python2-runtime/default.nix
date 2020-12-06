{ lib, buildPythonPackage, isPy3k, python
, antlr4
}:

buildPythonPackage rec {
  pname = "antlr4-python2-runtime";
  inherit (antlr4.runtime.cpp) version src;
  disabled = isPy3k;

  sourceRoot = "source/runtime/Python2";

  checkPhase = ''
    ${python.interpreter} tests/TestTokenStreamRewriter.py
  '';

  meta = with lib; {
    description = "Runtime for ANTLR";
    homepage = "https://www.antlr.org/";
    license = licenses.bsd3;
  };
}
