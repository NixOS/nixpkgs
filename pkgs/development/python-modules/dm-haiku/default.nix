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

let
  dm-haiku = buildPythonPackage rec {
    pname = "dm-haiku";
    version = "0.0.15";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "deepmind";
      repo = "dm-haiku";
      tag = "v${version}";
      hash = "sha256-phJ0f+effHQzuAVtPBR0bY3C0p//LBY7k1ci4mXBGfU=";
    };

    patches = [
      # https://github.com/deepmind/dm-haiku/pull/672
      (fetchpatch {
        name = "fix-find-namespace-packages.patch";
        url = "https://github.com/deepmind/dm-haiku/commit/728031721f77d9aaa260bba0eddd9200d107ba5d.patch";
        hash = "sha256-qV94TdJnphlnpbq+B0G3KTx5CFGPno+8FvHyu/aZeQE=";
      })
    ];

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
      dm-haiku
      dm-tree
      flax
      jaxlib
      optax
      pytest-xdist
      pytestCheckHook
      # rlax (broken dependency tensorflow-probability)
      tensorflow
    ];

    disabledTests = [
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
    passthru.tests.pytest = dm-haiku.overridePythonAttrs (_: {
      pname = "${pname}-tests";
      doCheck = true;

      # We don't have to install because the only purpose
      # of this passthru test is to, well, test.
      # This fixes having to set `catchConflicts` to false.
      dontInstall = true;
    });

    meta = {
      description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet";
      homepage = "https://github.com/deepmind/dm-haiku";
      changelog = "https://github.com/google-deepmind/dm-haiku/releases/tag/${src.tag}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ ndl ];
    };
  };
in
dm-haiku
