{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  jax,
  jaxtyping,
  typing-extensions,
  wadler-lindig,

  # tests
  beartype,
  optax,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "equinox";
  version = "0.13.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patrick-kidger";
    repo = "equinox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OETWXAcCp945mMrpC8U4gSBvEeQX8RoUGZR4irBs7Ak=";
  };

  # Relax speed constraints on tests that can fail on busy builders
  postPatch = ''
    substituteInPlace tests/test_while_loop.py \
      --replace-fail "speed < 0.1" "speed < 0.5" \
      --replace-fail "speed < 0.5" "speed < 1" \
      --replace-fail "speed < 1" "speed < 20" \
      --replace-fail "speed < 2" "speed < 20"
  '';

  build-system = [ hatchling ];

  dependencies = [
    jax
    jaxtyping
    typing-extensions
    wadler-lindig
  ];

  nativeCheckInputs = [
    beartype
    optax
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [
    # DeprecationWarning: The default axis_types will change in JAX v0.9.0 to jax.sharding.AxisType.Explicit.
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # ValueError: not enough values to unpack (expected 2, got 0)
    "tests/test_finalise_jaxpr.py"
  ];

  disabledTests = [
    # Failed: DID NOT WARN. No warnings of type (<class 'Warning'>,) were emitted.
    # Reported upstream: https://github.com/patrick-kidger/equinox/issues/1186
    "test_jax_transform_warn"

    # Flaky: AssertionError: Non-linear scaling detected
    "test_speed_buffer_while"
  ];

  pythonImportsCheck = [ "equinox" ];

  meta = {
    description = "JAX library based around a simple idea: represent parameterised functions (such as neural networks) as PyTrees";
    changelog = "https://github.com/patrick-kidger/equinox/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/patrick-kidger/equinox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
