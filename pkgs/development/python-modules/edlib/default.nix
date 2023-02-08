{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, edlib
, cython
, python
}:

buildPythonPackage {
  inherit (edlib) pname src meta;
  version = "1.3.9";

  disabled = pythonOlder "3.6";

  sourceRoot = "source/bindings/python";

  preBuild = ''
    ln -s ${edlib.src}/edlib .
  '';

  EDLIB_OMIT_README_RST = 1;
  EDLIB_USE_CYTHON = 1;

  nativeBuildInputs = [ cython ];
  buildInputs = [ edlib ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "edlib" ];

}
