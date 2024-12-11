{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gpytorch,
  linear-operator,
  multipledispatch,
  pyro-ppl,
  setuptools,
  setuptools-scm,
  torch,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "botorch";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "botorch";
    rev = "refs/tags/v${version}";
    hash = "sha256-CKlerCUadObpPq4jQAiFDBOZMHZ4QccAKQz30OFe64E=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    gpytorch
    linear-operator
    multipledispatch
    pyro-ppl
    scipy
    torch
  ];

  pythonRelaxDeps = [
    "gpytorch"
    "linear-operator"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # tests tend to get stuck on busy hosts, increase verbosity to find out
    # which specific tests get stuck
    "-vvv"
  ];

  disabledTests =
    [ "test_all_cases_covered" ]
    ++ lib.optionals (stdenv.buildPlatform.system == "x86_64-linux") [
      # stuck tests on hydra
      "test_moo_predictive_entropy_search"
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
    changelog = "https://github.com/pytorch/botorch/blob/${src.rev}/CHANGELOG.md";
    description = "Bayesian Optimization in PyTorch";
    homepage = "https://botorch.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
