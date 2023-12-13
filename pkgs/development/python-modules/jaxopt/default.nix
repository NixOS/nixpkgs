{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
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
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "google";
    repo = "jaxopt";
    rev = "refs/tags/jaxopt-v${version}";
    hash = "sha256-uVOd3knoku5fKBNXOhCikGtjDuW3TtRqev94OM/8Pgk=";
  };

  propagatedBuildInputs = [
    absl-py
    jax
    jaxlib
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [
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

  disabledTests = [
    # Stack frame issue
    "test_bisect"
  ];

  meta = with lib; {
    homepage = "https://jaxopt.github.io";
    description = "Hardware accelerated, batchable and differentiable optimizers in JAX";
    changelog = "https://github.com/google/jaxopt/releases/tag/jaxopt-v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
