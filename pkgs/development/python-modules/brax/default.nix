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

buildPythonPackage (finalAttrs: {
  pname = "brax";
  version = "0.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "brax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/oznBa44xKl+9T1YrTVhCbuKZj16V1BTlnmCGRbF45g=";
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

  disabledTests = [
    # AttributeError: 'functools.partial' object has no attribute 'value'
    "testModelEncoding0"
    "testModelEncoding1"
    "testTrain"
    "testTrainDomainRandomize"

    # ValueError: Error: no decoder found for mesh file 'meshes/pyramid.stl'
    "test_convex_convex"
    "test_dumps"
    "test_dumps_invalidstate_raises"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # Flaky:
    # AssertionError: Array(-0.00135638, dtype=float32) != 0.0 within 0.001 delta (Array(0.00135638, dtype=float32) difference)
    "test_pendulum_period2"
  ];

  disabledTestPaths = [
    # ValueError: matmul: Input operand 1 has a mismatch in its core dimension
    "brax/generalized/constraint_test.py"
  ];

  pythonImportsCheck = [ "brax" ];

  meta = {
    description = "Massively parallel rigidbody physics simulation on accelerator hardware";
    homepage = "https://github.com/google/brax";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
