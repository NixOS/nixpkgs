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
    version = "0.0.13";
    pyproject = true;

    # ImportError: `haiku.experimental.flax` features require `flax` to be installed.
    disabled = pythonAtLeast "3.13";

    src = fetchFromGitHub {
      owner = "deepmind";
      repo = "dm-haiku";
      tag = "v${version}";
      hash = "sha256-RJpQ9BzlbQ4X31XoJFnsZASiaC9fP2AdyuTAGINhMxs=";
    };

    patches = [
      # https://github.com/deepmind/dm-haiku/pull/672
      (fetchpatch {
        name = "fix-find-namespace-packages.patch";
        url = "https://github.com/deepmind/dm-haiku/commit/728031721f77d9aaa260bba0eddd9200d107ba5d.patch";
        hash = "sha256-qV94TdJnphlnpbq+B0G3KTx5CFGPno+8FvHyu/aZeQE=";
      })
    ];

    # AttributeError: jax.core.Var was removed in JAX v0.6.0. Use jax.extend.core.Var instead, and
    # see https://docs.jax.dev/en/latest/jax.extend.html for details.
    # Already on master: https://github.com/google-deepmind/dm-haiku/commit/cfe8480d253a93100bf5e2d24c40435a95399c96
    # TODO: remove at the next release
    postPatch = ''
      substituteInPlace haiku/_src/jaxpr_info.py \
        --replace-fail "jax.core.JaxprEqn" "jax.extend.core.JaxprEqn" \
        --replace-fail "jax.core.Var" "jax.extend.core.Var" \
        --replace-fail "jax.core.Jaxpr" "jax.extend.core.Jaxpr"
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
      dm-haiku
      dm-tree
      jaxlib
      optax
      pytest-xdist
      pytestCheckHook
      rlax
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
    ];

    disabledTestPaths = [
      # Those tests requires a more recent version of tensorflow. The current one (2.13) is not enough.
      "haiku/_src/integration/jax2tf_test.py"
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
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ ndl ];
    };
  };
in
dm-haiku
