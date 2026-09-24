{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  jaxlib,
  jmp,
  numpy,
  tabulate,

  # optional-dependencies
  jax,
  flax,

  # tests
  pytest-xdist,
  pytestCheckHook,
  bsuite,
  chex,
  cloudpickle,
  dill,
  dm-env,
  dm-tree,
  optax,
  rlax,
  tensorflow,
}:

buildPythonPackage (finalAttrs: {
  pname = "dm-haiku";
  version = "0.0.17";
  pyproject = true;
  __srtructuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "dm-haiku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CXEMEuQY6VyQ3Ahn1vYYN6slyqABSbIBeJuxJTPapvw=";
  };

  # https://github.com/deepmind/dm-haiku/pull/672
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "packages=find_namespace_packages(exclude=['*_test.py', 'examples'])," \
        "packages=find_namespace_packages(exclude=['*_test.py', 'examples*', 'docs*']),"
  '';

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    jaxlib # implicit runtime dependency
    jmp
    numpy
    tabulate
  ];

  optional-dependencies = {
    jax = [
      jax
      jaxlib
    ];
    flax = [ flax ];
  };

  pythonImportsCheck = [ "haiku" ];

  nativeCheckInputs = [
    bsuite
    chex
    cloudpickle
    dill
    dm-env
    dm-tree
    flax
    jaxlib
    optax
    pytest-xdist
    pytestCheckHook
    rlax
    tensorflow
  ];

  disabledTests = [
    # tensorflow.python.framework.errors_impl.InvalidArgumentError: Graph execution error:
    # Cannot deserialize computation: UNKNOWN: <unknown>:0: error: loc("erf"):
    # unregistered operation 'vhlo.composite_v2' found in dialect ('vhlo') that does not allow unknown operations
    "JaxToTfTest"

    # See https://github.com/deepmind/dm-haiku/issues/366.
    "test_jit_Recurrent"

    # Assertion errors
    "testShapeChecking0"
    "testShapeChecking1"

    # This test requires a more recent version of tensorflow. The current one (2.13) is not enough.
    "test_reshape_convert"

    # This test requires JAX support for double precision (64bit), but enabling this causes several
    # other tests to fail.
    # https://jax.readthedocs.io/en/latest/notebooks/Common_Gotchas_in_JAX.html#double-64bit-precision
    "test_doctest_haiku.experimental"

    # AssertionError: 1 != 0 : 1 doctests failed
    "test_doctest_haiku"

    # ValueError: pmap wrapped function must be passed at least one argument containing an array,
    # got empty *args=() and **kwargs={}
    "test_equivalent_when_passing_transformed_fn2"

    # AssertionError: ValueError not raised
    "test_passing_function_to_transform_pmap_transform"
    "test_passing_function_to_transform_pmap_transform_with_state"
  ];

  disabledTestPaths = [
    # Require rlax which is unavailable as its dependency tensorflow-probability is broken
    "examples/impala/actor_test.py"
    "examples/impala/learner_test.py"
    "examples/impala_lite_test.py"
  ];

  doCheck = false;

  # check in passthru.tests.pytest to escape infinite recursion with bsuite
  passthru.tests.pytest = finalAttrs.finalPackage.overrideAttrs {
    pname = "${finalAttrs.pname}-tests";
    doInstallCheck = true;

    # This is only a test derivation; its metadata still identifies the package as "dm-haiku"
    dontCheckPythonMetadata = true;
  };

  meta = {
    description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet";
    homepage = "https://github.com/deepmind/dm-haiku";
    changelog = "https://github.com/google-deepmind/dm-haiku/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
