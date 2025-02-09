{
  lib,
  stdenv,
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
  flaxlib,
  keras,
  pytestCheckHook,
  pytest-xdist,
  sphinx,
  tensorflow,
  treescope,

  # optional-dependencies
  matplotlib,

  writeScript,
  tomlq,
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    tag = "v${version}";
    hash = "sha256-+URbQGnmqmSNgucEyWvI5DMnzXjpmJzLA+Pho2lX+S4=";
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
    flaxlib
    keras
    pytestCheckHook
    pytest-xdist
    sphinx
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
    # See https://github.com/google/flax/issues/3232.
    "tests/jax_utils_test.py"
  ];

  disabledTests =
    [
      # Failing with AssertionError since the jax update to 0.5.0
      "test_basic_demo_single"
      "test_batch_norm_multi_init"
      "test_multimetric"
      "test_split_merge"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # SystemError: nanobind::detail::nb_func_error_except(): exception could not be translated!
      "test_ref_changed"
      "test_structure_changed"
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
