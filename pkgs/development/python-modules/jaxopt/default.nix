{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "jaxopt";
    tag = "jaxopt-v${version}";
    hash = "sha256-vPXrs8J81O+27w9P/fEFr7w4xClKb8T0IASD+iNhztQ=";
  };

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
