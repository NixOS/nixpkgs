{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  jax,
  jaxlib,
  numpy,
  optax,
  scipy,
  typing-extensions,

  # optional-dependencies
  jax-tap,
  tqdm,

  # checks
  chex,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "blackjax";
  version = "1.6.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "blackjax-devs";
    repo = "blackjax";
    tag = finalAttrs.version;
    hash = "sha256-NO/CvYtxfAid3ETpj5DcNQPdARP2cwqy9p0kHOybvNg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jax
    jaxlib
    numpy
    optax
    scipy
    typing-extensions
  ];

  optional-dependencies = {
    progress = [
      jax-tap
      tqdm
    ];
  };

  nativeCheckInputs = [
    chex
    pytestCheckHook
    pytest-xdist
  ]
  ++ finalAttrs.passthru.optional-dependencies.progress;

  disabledTestPaths = [
    "tests/test_benchmarks.py"

    # Assertion errors on numerical values
    "tests/mcmc/test_integrators.py"
  ];

  disabledTests = [
    # too slow
    "test_adaptive_tempered_smc"

    # AssertionError: False is not true : f32: controller never escalated (U=0);
    # axis-aligned spike would do this, ensure u_dir is non-axis-aligned
    "test_escalated_e2e_smoke_f32_and_x64"

    # AssertionError on numerical values
    "test_barker"
    "test_imm_shrinkage_seed_influence_persists_diagonal"
    "test_laps"
    "test_mclmc"
    "test_mcse4"
    "test_mean_and_std"
    "test_normal_univariate"
    "test_nuts__with_device"
    "test_nuts__with_jit"
    "test_nuts__without_device"
    "test_nuts__without_jit"
    "test_smc__with_jit"
    "test_smc_waste_free__with_jit"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # AssertionError: Not equal to tolerance rtol=1e-07, atol=1e-05
    "test_equal_matrices"
    "test_pop_oldest_exactness_k5_d5_n10_nwraps2"
    "test_restart_after_reset_matches_fresh_accumulation"
    "test_skips_first_offset_steps"
    "test_split_pop_k1_degenerate"
  ];

  pythonImportsCheck = [ "blackjax" ];

  meta = {
    homepage = "https://blackjax-devs.github.io/blackjax";
    description = "Sampling library designed for ease of use, speed and modularity";
    changelog = "https://github.com/blackjax-devs/blackjax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
