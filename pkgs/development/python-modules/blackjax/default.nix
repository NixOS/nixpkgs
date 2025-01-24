{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  fastprogress,
  jax,
  jaxlib,
  jaxopt,
  optax,
  typing-extensions,

  # checks
  pytestCheckHook,
  pytest-xdist,

  stdenv,
}:

buildPythonPackage rec {
  pname = "blackjax";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = "blackjax";
    rev = "refs/tags/${version}";
    hash = "sha256-qaQBbRAKExRHr4Uhm5/Q1Ydon6ePsjG2PWbwSdR9QZM=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    fastprogress
    jax
    jaxlib
    jaxopt
    optax
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTestPaths =
    [ "tests/test_benchmarks.py" ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Assertion errors on numerical values
      "tests/mcmc/test_integrators.py"
    ];

  disabledTests =
    [
      # too slow
      "test_adaptive_tempered_smc"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Numerical test (AssertionError)
      # https://github.com/blackjax-devs/blackjax/issues/668
      "test_chees_adaptation"
    ];

  pythonImportsCheck = [ "blackjax" ];

  meta = {
    homepage = "https://blackjax-devs.github.io/blackjax";
    description = "Sampling library designed for ease of use, speed and modularity";
    changelog = "https://github.com/blackjax-devs/blackjax/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
