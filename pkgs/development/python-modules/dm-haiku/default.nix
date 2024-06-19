{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  absl-py,
  flax,
  jaxlib,
  jmp,
  numpy,
  tabulate,
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
    version = "0.0.12";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "deepmind";
      repo = "dm-haiku";
      rev = "refs/tags/v${version}";
      hash = "sha256-aJRXlMq4CNMH3ZSTDP8MgnVltdSc8l5raw4//KccL48=";
    };

    patches = [
      # https://github.com/deepmind/dm-haiku/pull/672
      (fetchpatch {
        name = "fix-find-namespace-packages.patch";
        url = "https://github.com/deepmind/dm-haiku/commit/728031721f77d9aaa260bba0eddd9200d107ba5d.patch";
        hash = "sha256-qV94TdJnphlnpbq+B0G3KTx5CFGPno+8FvHyu/aZeQE=";
      })
    ];

    propagatedBuildInputs = [
      absl-py
      flax
      jaxlib
      jmp
      numpy
      tabulate
    ];

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

    meta = with lib; {
      description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet.";
      homepage = "https://github.com/deepmind/dm-haiku";
      license = licenses.asl20;
      maintainers = with maintainers; [ ndl ];
    };
  };
in
dm-haiku
