{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  jaxlib,
  setuptools-scm,

  # dependencies
  jax,
  msgpack,
  numpy,
  optax,
  orbax-checkpoint,
  pyyaml,
  rich,
  tensorstore,
  typing-extensions,

  # checks
  cloudpickle,
  einops,
  keras,
  pytest-xdist,
  pytestCheckHook,
  tensorflow,
  treescope,

  # optional-dependencies
  matplotlib,
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    rev = "refs/tags/v${version}";
    hash = "sha256-iDWuUJKO7V4QrbVsS4ALgy6fbllOC43o7W4mhjtZ9xc=";
  };

  build-system = [
    jaxlib
    setuptools-scm
  ];

  dependencies = [
    jax
    msgpack
    numpy
    optax
    orbax-checkpoint
    pyyaml
    rich
    tensorstore
    typing-extensions
  ];

  optional-dependencies = {
    all = [ matplotlib ];
  };

  pythonImportsCheck = [ "flax" ];

  nativeCheckInputs = [
    cloudpickle
    einops
    keras
    pytest-xdist
    pytestCheckHook
    tensorflow
    treescope
  ];

  pytestFlagsArray = [
    "-W ignore::FutureWarning"
    "-W ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # Docs test, needs extra deps + we're not interested in it.
    "docs/_ext/codediff_test.py"
    # The tests in `examples` are not designed to be executed from a single test
    # session and thus either have the modules that conflict with each other or
    # wrong import paths, depending on how they're invoked. Many tests also have
    # dependencies that are not packaged in `nixpkgs` (`clu`, `jgraph`,
    # `tensorflow_datasets`, `vocabulary`) so the benefits of trying to run them
    # would be limited anyway.
    "examples/*"
    "flax/nnx/examples/*"
    # See https://github.com/google/flax/issues/3232.
    "tests/jax_utils_test.py"
    # Too old version of tensorflow:
    # ModuleNotFoundError: No module named 'keras.api._v2'
    "tests/tensorboard_test.py"
  ];

  disabledTests = [
    # ValueError: Checkpoint path should be absolute
    "test_overwrite_checkpoints0"
    # Fixed in more recent versions of jax: https://github.com/google/flax/issues/4211
    # TODO: Re-enable when jax>0.4.28 will be available in nixpkgs
    "test_vmap_and_cond_passthrough" # ValueError: vmap has mapped output but out_axes is None
    "test_vmap_and_cond_passthrough_error" # AssertionError: "at vmap.*'broadcast'.*got axis spec ...
  ];

  meta = {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    changelog = "https://github.com/google/flax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
