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

buildPythonPackage (finalAttrs: {
  pname = "jaxopt";
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "jaxopt";
    tag = "jaxopt-v${finalAttrs.version}";
    hash = "sha256-vPXrs8J81O+27w9P/fEFr7w4xClKb8T0IASD+iNhztQ=";
  };

  postPatch =
    # TypeError: LogisticRegression.__init__() got an unexpected keyword argument 'multi_class'
    ''
      substituteInPlace jaxopt/_src/test_util.py \
        --replace-fail "multi_class=multiclass," ""
    ''
    # AttributeError: jax.experimental.enable_x64 was removed in JAX v0.9.0; use jax.enable_x64(True) instead.
    + ''
      substituteInPlace \
        tests/zoom_linesearch_test.py \
        tests/lbfgsb_test.py \
        tests/lbfgs_test.py \
        --replace-fail \
          "jax.experimental.enable_x64()" \
          "jax.enable_x64(True)"
    '';

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
    changelog = "https://github.com/google/jaxopt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
