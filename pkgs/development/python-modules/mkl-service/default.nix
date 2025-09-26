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
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    tag = "v${version}";
    hash = "sha256-uP4TzBLhlpT83FIYCjolP3QN5/90YjBOnauy780gUJc=";
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

  meta = with lib; {
    description = "Python hooks for Intel(R) Math Kernel Library runtime control settings";
    homepage = "https://github.com/IntelPython/mkl-service";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
