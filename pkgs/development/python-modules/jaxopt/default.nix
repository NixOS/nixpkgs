{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pytest-xdist
, pytestCheckHook
, absl-py
, cvxpy
, jax
, jaxlib
, matplotlib
, numpy
, optax
, scipy
, scikit-learn
}:

buildPythonPackage rec {
  pname = "jaxopt";
  version = "0.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "google";
    repo = "jaxopt";
    rev = "refs/tags/jaxopt-v${version}";
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
  ];

  propagatedBuildInputs = [
    absl-py
    jax
    jaxlib
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    cvxpy
    optax
    scikit-learn
  ];

  pythonImportsCheck = [
    "jaxopt"
    "jaxopt.implicit_diff"
    "jaxopt.linear_solve"
    "jaxopt.loss"
    "jaxopt.tree_util"
  ];

  disabledTests = lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # https://github.com/google/jaxopt/issues/577
    "test_binary_logit_log_likelihood"
    "test_solve_sparse"
    "test_logreg_with_intercept_manual_loop3"
  ];

  meta = with lib; {
    homepage = "https://jaxopt.github.io";
    description = "Hardware accelerated, batchable and differentiable optimizers in JAX";
    changelog = "https://github.com/google/jaxopt/releases/tag/jaxopt-v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
