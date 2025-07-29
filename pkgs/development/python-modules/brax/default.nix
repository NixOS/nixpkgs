{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  hatchling,

  # dependencies
  absl-py,
  etils,
  flask,
  flask-cors,
  flax,
  jax,
  jaxlib,
  jaxopt,
  jinja2,
  ml-collections,
  mujoco,
  mujoco-mjx,
  numpy,
  optax,
  orbax-checkpoint,
  pillow,
  scipy,
  tensorboardx,
  typing-extensions,

  # tests
  dm-env,
  gym,
  pytestCheckHook,
  pytest-xdist,
  transforms3d,
}:

buildPythonPackage rec {
  pname = "brax";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brax";
    tag = "v${version}";
    hash = "sha256-/eb0WjMzHwD1tjTyZ2fb2dzvGrWnyOLcVLOx4BeKvqk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    absl-py
    etils
    flask
    flask-cors
    flax
    jax
    jaxlib
    jaxopt
    jinja2
    ml-collections
    mujoco
    mujoco-mjx
    numpy
    optax
    orbax-checkpoint
    pillow
    scipy
    tensorboardx
    typing-extensions
  ];

  nativeCheckInputs = [
    dm-env
    gym
    pytestCheckHook
    pytest-xdist
    transforms3d
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # Flaky:
    # AssertionError: Array(-0.00135638, dtype=float32) != 0.0 within 0.001 delta (Array(0.00135638, dtype=float32) difference)
    "test_pendulum_period2"
  ];

  disabledTestPaths = [
    # ValueError: matmul: Input operand 1 has a mismatch in its core dimension
    "brax/generalized/constraint_test.py"
  ];

  pythonImportsCheck = [
    "brax"
  ];

  meta = {
    description = "Massively parallel rigidbody physics simulation on accelerator hardware";
    homepage = "https://github.com/google/brax";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
