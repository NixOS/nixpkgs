{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  jaxtyping,
  linear-operator,
  mpmath,
  scikit-learn,
  scipy,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gpytorch";
<<<<<<< HEAD
  version = "1.14.3";
=======
  version = "1.14.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = "gpytorch";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AuWVNAduh2y/sLIJAXg/9YgpFa21d1sbRHlcdG5cpJ8=";
=======
    hash = "sha256-yDIGiA7q4e6T7SdnO+ALcc3ezmJK964T5Nn48+NGJV8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaxtyping
    linear-operator
    mpmath
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gpytorch" ];

  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
    "test_optimization_optimal_error"
    # https://github.com/cornellius-gp/gpytorch/issues/2396
    "test_t_matmul_matrix"
  ];

<<<<<<< HEAD
  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Hang forever
    "test/examples/test_spectral_mixture_gp_regression.py"
    "test/kernels/test_spectral_mixture_kernel.py"
    "test/utils/test_nearest_neighbors.py"
    "test/variational/test_nearest_neighbor_variational_strategy.py"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    downloadPage = "https://github.com/cornellius-gp/gpytorch";
    changelog = "https://github.com/cornellius-gp/gpytorch/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
