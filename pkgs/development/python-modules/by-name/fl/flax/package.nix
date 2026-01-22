{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
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

  # optional-dependencies
  matplotlib,

  # tests
  cloudpickle,
  keras,
  einops,
  flaxlib,
  pytestCheckHook,
  pytest-xdist,
  sphinx,
  tensorflow,
  treescope,

  writeScript,
  tomlq,
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    tag = "v${version}";
    hash = "sha256-Wdfc35/iah98C5WNYZWiAd2FJUJlyGLJ8xELpuYD3GU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    flaxlib
    jax
    msgpack
    numpy
    optax
    orbax-checkpoint
    pyyaml
    rich
    tensorstore
    treescope
    typing-extensions
  ];

  optional-dependencies = {
    all = [ matplotlib ];
  };

  pythonImportsCheck = [ "flax" ];

  nativeCheckInputs = [
    cloudpickle
    keras
    einops
    pytestCheckHook
    pytest-xdist
    sphinx
    tensorflow
  ];

  pytestFlags = [
    # FutureWarning: In the future `np.object` will be defined as the corresponding NumPy scalar.
    "-Wignore::FutureWarning"
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
  ];

  disabledTests = [
    # AssertionError: [Chex] Function 'add' is traced > 1 times!
    "PadShardUnpadTest"

    # AssertionError: nnx_model.kernel.value.sharding = NamedSharding(...
    "test_linen_to_nnx_metadata"

    # AssertionError: 'Linear_0' not found in State({})
    "test_compact_basic"
    # KeyError: 'intermediates'
    "test_linen_submodule"
    "test_pure_nnx_submodule"
    # KeyError: 'counts
    "test_mutable_state"
    # AttributeError: 'Top' object has no attribute '_pytree__state'. Did you mean: '_pytree__flatten'?
    "test_shared_modules"
    # AttributeError: 'MLP' object has no attribute 'scope
    "test_transforms"
  ];

  passthru = {
    updateScript = writeScript "update.sh" ''
      nix-update flax # does not --build by default
      nix-build . -A flax.src # src is essentially a passthru
      nix-update flaxlib --version="$(${lib.getExe tomlq} <result/Cargo.toml .something.version)" --commit
    '';
  };

  meta = {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    changelog = "https://github.com/google/flax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
}
