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
  version = "1.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = "blackjax";
    tag = version;
    hash = "sha256-2GTjKjLIWFaluTjdWdUF9Iim973y81xv715xspghRZI=";
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

  disabledTestPaths = [
    "tests/test_benchmarks.py"

    # Assertion errors on numerical values
    "tests/mcmc/test_integrators.py"
  ];

  disabledTests =
    [
      # too slow
      "test_adaptive_tempered_smc"

      # AssertionError on numerical values
      "test_barker"
      "test_mclmc"
      "test_mcse4"
      "test_normal_univariate"
      "test_nuts__with_device"
      "test_nuts__with_jit"
      "test_nuts__without_device"
      "test_nuts__without_jit"
      "test_smc_waste_free__with_jit"
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
