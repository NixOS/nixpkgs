{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  treescope,
  typing-extensions,

  # tests
  cloudpickle,
  keras,
  einops,
  flaxlib,
  pytestCheckHook,
  pytest-xdist,
  sphinx,
  tensorflow,
  torch,

  writeScript,
  tomlq,
}:

buildPythonPackage (finalAttrs: {
  pname = "flax";
  version = "0.12.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zh5PE9pq+loJCIW5EPvtWTco/ouIK3TzJ0o3Ydthz00=";
  };

  patches = [
    # Adapt to the `jax.experimental.hijax` changes in jax 0.11.2, which removed `HiPrimitive` and
    # renamed `VJPHiPrimitive` to `HiPrim`.
    # Both commits are merged upstream but not part of any release yet (latest is 0.12.9).
    (fetchpatch {
      name = "hijax-migrate-hiprimitive-to-vjphiprimitive.patch";
      url = "https://github.com/google/flax/commit/d2b105f0c688d94f4334a7d74e573da382f0b71d.patch";
      hash = "sha256-fQAQ2AWRYB5RAHkcRsgcNGgusvJxVpiGK6PRn+ZPv7M=";
    })
    (fetchpatch {
      name = "hijax-rename-vjphiprimitive-to-hiprim.patch";
      url = "https://github.com/google/flax/commit/01854da11286b4109c59d7fd9205f3822fe807d6.patch";
      hash = "sha256-c28ppUZZkX/5qlLg88r0bQDLWMzkLr7MkzUhGkUm9gA=";
    })
  ];

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

  pythonImportsCheck = [ "flax" ];

  nativeCheckInputs = [
    cloudpickle
    keras
    einops
    pytestCheckHook
    pytest-xdist
    sphinx
    tensorflow
    torch
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
    changelog = "https://github.com/google/flax/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
