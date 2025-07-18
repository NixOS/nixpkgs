{
  lib,
  buildPythonPackage,
  ckdl,
  cmake,
  ninja,
  setuptools,
  scikit-build,
  cython,
  unittestCheckHook,
}:

buildPythonPackage {
  inherit (ckdl)
    pname
    version
    src
    ;
  pyproject = true;

  build-system = [
    cmake
    ninja
    setuptools
    scikit-build
    cython
  ];

  dontUseCmakeConfigure = true;

  checkPhase = ''
    runHook preCheck

    python3 bindings/python/tests/ckdl_test.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "ckdl" ];

  meta = lib.removeAttrs ckdl.meta [ "outputsToInstall" ];
}
