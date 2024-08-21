{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  linear-operator,
  scikit-learn,
  setuptools,
  setuptools-scm,
  wheel,
  torch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gpytorch";
  version = "1.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8W0QSiXl+C86m5yaI9KfGN92uA2VGjGwQt6DI/1NaQE=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/cornellius-gp/gpytorch/pull/2545
      name = "scipy-1.14-compatibility.patch";
      url = "https://github.com/cornellius-gp/gpytorch/commit/2562be472521b8aec366de2619e3130a96fab982.patch";
      excludes = [ "setup.py" ];
      hash = "sha256-znOFpN6go2iIxP24VjJLKF3Laxcr4xV/IyP2y36g4QY=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    linear-operator
    scikit-learn
    torch
  ];

  checkInputs = [ pytestCheckHook ];

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
    description = "Highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
