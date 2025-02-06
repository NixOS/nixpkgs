{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  jax,
  matplotlib,
  numpy,
  scipy,

  # tests
  cvxpy,
  optax,
  pytest-xdist,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "jaxopt";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "jaxopt";
    tag = "jaxopt-v${version}";
    hash = "sha256-T/BHSnuk3IRuLkBj3Hvb/tFIb7Au25jjQtvwL28OU1U=";
  };

  patches = [
    # fix failing tests from scipy 1.12 update
    # https://github.com/google/jaxopt/pull/574
    (fetchpatch {
      name = "scipy-1.12-fix-tests.patch";
      url = "https://github.com/google/jaxopt/commit/48b09dc4cc93b6bc7e6764ed5d333f9b57f3493b.patch";
      hash = "sha256-v+617W7AhxA1Dzz+DBtljA4HHl89bRTuGi1QfatobNY=";
    })
    # fix invalid string escape sequences
    (fetchpatch {
      name = "fix-escape-sequences.patch";
      url = "https://github.com/google/jaxopt/commit/f5bb530f5f000d0739c9b26eee2d32211eb99f40.patch";
      hash = "sha256-E0ZXIfzWxKHuiBn4lAWf7AjNtll7OJU/NGZm6PTmhzo=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    jax
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [
    cvxpy
    optax
    pytest-xdist
    pytestCheckHook
    scikit-learn
  ];

  pythonImportsCheck = [
    "jaxopt"
    "jaxopt.implicit_diff"
    "jaxopt.linear_solve"
    "jaxopt.loss"
    "jaxopt.tree_util"
  ];

  disabledTests = [
    # https://github.com/google/jaxopt/issues/592
    "test_solve_sparse"

    # https://github.com/google/jaxopt/issues/593
    # Makes the test suite crash
    "test_dtype_consistency"

    # AssertionError: Not equal to tolerance rtol=1e-06, atol=1e-06
    # https://github.com/google/jaxopt/issues/618
    "test_binary_logit_log_likelihood"

    # AssertionError (flaky numerical tests)
    "test_Rosenbrock2"
    "test_Rosenbrock5"
    "test_gradient1"
    "test_inv_hessian_product_pytree3"
    "test_logreg_with_intercept_manual_loop3"
    "test_multiclass_logreg6"
  ];

  meta = {
    homepage = "https://jaxopt.github.io";
    description = "Hardware accelerated, batchable and differentiable optimizers in JAX";
    changelog = "https://github.com/google/jaxopt/releases/tag/jaxopt-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
