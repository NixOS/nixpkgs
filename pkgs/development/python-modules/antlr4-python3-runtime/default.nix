{ lib
, buildPythonPackage
<<<<<<< HEAD
, setuptools
, python
, antlr4
}:
=======
, isPy3k
, python
, antlr4 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;
<<<<<<< HEAD

  format = "pyproject";

  disabled = python.pythonOlder "3.6";

  sourceRoot = "${src.name}/runtime/Python3";

  nativeBuildInputs = [
    setuptools
  ];

  # We use an asterisk because this expression is used also for old antlr
  # versions, where there the tests directory is `test` and not `tests`.
  # See e.g in package `baserow`.
=======
  disabled = python.pythonOlder "3.6";

  sourceRoot = "source/runtime/Python3";

  # in 4.9, test was renamed to tests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
