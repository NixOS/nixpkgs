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
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "refs/tags/v${version}";
    hash = "sha256-o5mjZhqQc7tu44EjrScuGzv6pZNlnZnndMIAhl8pY5o=";
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
