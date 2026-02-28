{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  mkl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.7.0dev1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    tag = version;
    hash = "sha256-ok4QmMBFVdE185mkud6tQi2XQPbzijMabo2KtL3qVC0=";
  };

  build-system = [
    cython
    setuptools
  ];

  env.MKLROOT = mkl;

  dependencies = [ mkl ];

  pythonImportsCheck = [ "mkl" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd $out
  '';

  disabledTests = [
    # require SIMD compilation
    "test_cbwr_all"
    "test_cbwr_branch"
  ];

  meta = {
    description = "Python hooks for Intel(R) Math Kernel Library runtime control settings";
    homepage = "https://github.com/IntelPython/mkl-service";
    license = lib.licenses.bsd3;
  };
}
