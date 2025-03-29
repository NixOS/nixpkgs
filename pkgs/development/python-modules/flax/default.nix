{
  lib,
  stdenv,
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

  # dependencies
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
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "flax";
    tag = "v${version}";
    hash = "sha256-+3PQPRVju9kw/4KWeifD8LhY4t6EzakhYISubMxrMw4=";
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

  pytestFlagsArray = [
    # DeprecationWarning: linear_util.wrap_init is missing a DebugInfo object.
    "-W"
    "ignore::DeprecationWarning"
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
      # AttributeError: module 'jax.api_util' has no attribute 'debug_info'
      # https://github.com/google/flax/issues/4585
      "test_basic_seq_lengths"
      "test_bidirectional"
      "test_big_resnet"
      "test_custom_merge_fn"
      "test_jit_scan_retracing_retracing"
      "test_lazy_init"
      "test_lazy_init"
      "test_lazy_init_fails_on_data_dependence"
      "test_lazy_init_fails_on_data_dependence"
      "test_lifted_transform"
      "test_lifted_transform_no_rename"
      "test_multi_method_class_transform"
      "test_numerical_equivalence"
      "test_numerical_equivalence_single_batch"
      "test_numerical_equivalence_single_batch_nn_scan"
      "test_numerical_equivalence_with_mask"
      "test_pjit_scan_over_layers"
      "test_remat_scan"
      "test_return_carry"
      "test_reverse"
      "test_reverse_but_keep_order"
      "test_rnn_basic_forward"
      "test_rnn_equivalence_with_flax_linen"
      "test_rnn_multiple_batch_dims"
      "test_rnn_time_major"
      "test_rnn_unroll"
      "test_rnn_with_spatial_dimensions"
      "test_same_key"
      "test_scan"
      "test_scan_compact_count"
      "test_scan_decorated"
      "test_scan_negative_axes"
      "test_scan_of_setup_parameter"
      "test_scan_over_layers"
      "test_scan_shared_params"
      "test_scan_unshared_params"
      "test_scan_with_axes"
      "test_shared_cell"
      "test_toplevel_submodule_adoption_pytree_transform"
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
