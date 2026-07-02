{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  gpytorch,
  linear-operator,
  multipledispatch,
  pyre-extensions,
  pyro-ppl,
  scipy,
  threadpoolctl,
  torch,
  typing-extensions,

  # optional-dependencies
  pymoo,

  # tests
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "botorch";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "botorch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KWkRdgOAhWoVRoBn0XvKhTQX3KPHJrzqWoiaKrYzi7o=";
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
    threadpoolctl
    torch
    typing-extensions
  ];

  optional-dependencies = {
    pymoo = [
      pymoo
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires unpackaged pfns
    "test_community/models/test_prior_fitted_network.py"
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
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    # stuck tests on hydra
    "test_moo_predictive_entropy_search"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: Failed to initialize cpuinfo!
    "test_append_features"
    "test_delattr_ctx"
    "test_input_perturbation"
    "test_module_rollback_ctx"
    "test_parameter_rollback_ctx"
    "test_zero_grad_ctx"
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
    changelog = "https://github.com/meta-pytorch/botorch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
