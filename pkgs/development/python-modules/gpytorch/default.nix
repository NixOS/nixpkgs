{ lib
, buildPythonPackage
, fetchFromGitHub
, linear_operator
, scikit-learn
, setuptools
, setuptools-scm
, wheel
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gpytorch";
  version = "1.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cpkfjx5G/4duL1Rr4nkHTHi03TDcYbcx3bKP2Ny7Ijo=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    linear_operator
    scikit-learn
    torch
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gpytorch" ];

  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
    # https://github.com/cornellius-gp/gpytorch/issues/2396
    "test_t_matmul_matrix"
  ];

  meta = with lib; {
    description = "A highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
