{ lib
, buildPythonPackage
, setuptools
, python
, antlr4
}:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;

  format = "pyproject";

  disabled = python.pythonOlder "3.6";

  sourceRoot = "${src.name}/runtime/Python3";

  nativeBuildInputs = [
    setuptools
  ];

  # We use an asterisk because this expression is used also for old antlr
  # versions, where there the tests directory is `test` and not `tests`.
  # See e.g in package `baserow`.
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
