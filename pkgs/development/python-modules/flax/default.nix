{
  lib,
  buildPythonPackage,
  cloudpickle,
  einops,
  fetchFromGitHub,
  jax,
  jaxlib,
  keras,
  matplotlib,
  msgpack,
  numpy,
  optax,
  orbax-checkpoint,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich,
  setuptools-scm,
  tensorflow,
  tensorstore,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.8.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZwqKZdJ9LOfWTav5nE9xMsMw/DbryqQUuu5fqeugBzY=";
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

  passthru.optional-dependencies = {
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
    # Requires tree
    "tests/tensorboard_test.py"
  ];

  disabledTests = [
    # ValueError: Checkpoint path should be absolute
    "test_overwrite_checkpoints0"
  ];

  meta = {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    changelog = "https://github.com/google/flax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
