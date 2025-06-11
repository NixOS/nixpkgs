{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  dm-env,
  etils,
  flask,
  flask-cors,
  flax,
  grpcio,
  gym,
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
  pytinyrenderer,
  scipy,
  tensorboardx,
  trimesh,

  # tests
  pytestCheckHook,
  pytest-xdist,
  transforms3d,
}:

buildPythonPackage rec {
  pname = "brax";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brax";
    tag = "v${version}";
    hash = "sha256-whkkqTTy5CY6soyS5D7hWtBZuVHc6si1ArqwLgzHDkw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    # TODO: remove dm_env after dropping legacy v1 code
    dm-env
    etils
    flask
    flask-cors
    flax
    # TODO: remove grpcio and gym after dropping legacy v1 code
    grpcio
    gym
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
    # TODO: remove pytinyrenderer after dropping legacy v1 code
    pytinyrenderer
    scipy
    tensorboardx
    trimesh
  ];

  nativeCheckInputs = [
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
