{ buildPythonPackage
, fetchFromGitHub
, jaxlib
, jax
, keras
, lib
, matplotlib
, msgpack
, numpy
, optax
, pytest-xdist
, pytestCheckHook
, tensorflow
, fetchpatch
, rich
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4BYfrwEddA2LCMyDO6PBBYdMVTqqDxhzMCZ5JIIml3g=";
  };

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    jax
    matplotlib
    msgpack
    numpy
    optax
    rich
  ];

  pythonImportsCheck = [
    "flax"
  ];

  checkInputs = [
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
  ];

  disabledTests = [
    # See https://github.com/google/flax/issues/2554.
    "test_async_save_checkpoints"
    "test_jax_array0"
    "test_jax_array1"
    "test_keep0"
    "test_keep1"
    "test_optimized_lstm_cell_matches_regular"
    "test_overwrite_checkpoints"
    "test_save_restore_checkpoints_target_empty"
    "test_save_restore_checkpoints_target_none"
    "test_save_restore_checkpoints_target_singular"
    "test_save_restore_checkpoints_w_float_steps"
    "test_save_restore_checkpoints"
  ];

  meta = with lib; {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
