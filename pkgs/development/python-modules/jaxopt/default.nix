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
  version = "0.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-WOsr/Dvguu9/qX6+LMlAKM3EANtYPtDu8Uo2157+bs0=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
