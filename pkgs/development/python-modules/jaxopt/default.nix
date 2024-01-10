{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
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

  meta = with lib; {
    homepage = "https://jaxopt.github.io";
    description = "Hardware accelerated, batchable and differentiable optimizers in JAX";
    changelog = "https://github.com/google/jaxopt/releases/tag/jaxopt-v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
