{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gpytorch,
  linear-operator,
  multipledispatch,
  pyre-extensions,
  pyro-ppl,
  setuptools,
  setuptools-scm,
  torch,
  scipy,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "botorch";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "botorch";
    tag = "v${version}";
    hash = "sha256-IyRi5kXePnDv2q6SrXLtdltQ1/2/zQ3EBx5phtuX8sE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    gpytorch
    linear-operator
    multipledispatch
    pyre-extensions
    pyro-ppl
    scipy
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_all_cases_covered"

    # Skip tests that take too much time
    "TestQMultiObjectivePredictiveEntropySearch"
    "TestQPredictiveEntropySearch"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # RuntimeError: Boolean value of Tensor with more than one value is ambiguous
    "test_optimize_acqf_mixed_binary_only"
  ]
  ++ lib.optionals (stdenv.buildPlatform.system == "x86_64-linux") [
    # stuck tests on hydra
    "test_moo_predictive_entropy_search"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # RuntimeError: required keyword attribute 'value' has the wrong type
    "test_posterior_in_trace_mode"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Numerical error slightly above threshold
    # AssertionError: Tensor-likes are not close!
    "test_model_list_gpytorch_model"
  ];

  pythonImportsCheck = [ "botorch" ];

  # needs lots of undisturbed CPU time or prone to getting stuck
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    changelog = "https://github.com/pytorch/botorch/blob/${src.tag}/CHANGELOG.md";
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
