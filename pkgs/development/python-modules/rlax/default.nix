{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  absl-py,
  chex,
  distrax,
  dm-env,
  jax,
  jaxlib,
  numpy,

  # tests
  dm-haiku,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rlax";
  version = "0.1.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "rlax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E/zYFd5bfx58FfA3uR7hzRAIs844QzJA8TZTwmwDByk=";
  };

  # TypeError: clip() got an unexpected keyword argument 'a_min'
  postPatch = ''
    substituteInPlace rlax/_src/mpo_ops.py \
      --replace-fail "a_min=" "min="
  '';

  build-system = [
    flit-core
  ];

  dependencies = [
    absl-py
    chex
    distrax
    dm-env
    jax
    jaxlib
    numpy
  ];

  nativeCheckInputs = [
    dm-haiku
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rlax" ];

  disabledTests = [
    # AssertionError: Array(2, dtype=int32) != 0
    "test_categorical_sample__with_device"
    "test_categorical_sample__with_jit"
    "test_categorical_sample__without_device"
    "test_categorical_sample__without_jit"

    # RuntimeError: Attempted to set 4 devices, but 1 CPUs already available:
    # ensure that `set_n_cpu_devices` is executed before any JAX operation.
    "test_cross_replica_scatter_add0"
    "test_cross_replica_scatter_add1"
    "test_cross_replica_scatter_add2"
    "test_cross_replica_scatter_add3"
    "test_cross_replica_scatter_add4"
    "test_learn_scale_shift"
    "test_normalize_unnormalize_is_identity"
    "test_outputs_preserved"
    "test_scale_bounded"
    "test_slow_update"
    "test_unnormalize_linear"
  ];

  meta = {
    description = "Library of reinforcement learning building blocks in JAX";
    homepage = "https://github.com/deepmind/rlax";
    changelog = "https://github.com/google-deepmind/rlax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
})
