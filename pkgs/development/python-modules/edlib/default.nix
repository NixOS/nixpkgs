{
  buildPythonPackage,
  pythonOlder,
  edlib,
  cython,
  python,
  setuptools,
}:

buildPythonPackage {
  inherit (edlib)
    pname
    src
    version
    meta
    ;
  pyproject = true;

  sourceRoot = "${edlib.src.name}/bindings/python";

  preBuild = ''
    ln -s ${edlib.src}/edlib .
  '';

  env.EDLIB_OMIT_README_RST = 1;
  env.EDLIB_USE_CYTHON = 1;

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [ edlib ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "edlib" ];
}
