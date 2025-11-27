{
  lib,
  stdenv,
  absl-py,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  aiofiles,
  etils,
  humanize,
  importlib-resources,
  jax,
  msgpack,
  nest-asyncio,
  numpy,
  protobuf,
  psutil,
  pyyaml,
  simplejson,
  tensorstore,
  typing-extensions,

  # tests
  chex,
  google-cloud-logging,
  mock,
  optax,
  portpicker,
  pytest-xdist,
  pytestCheckHook,
  safetensors,
  torch,
}:

buildPythonPackage rec {
  pname = "orbax-checkpoint";
  version = "0.11.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "orbax";
    tag = "v${version}";
    hash = "sha256-y8l0AVGt2t5zLX+x+yuWHsEDy68agpXIkrew+zfYGXU=";
  };

  sourceRoot = "${src.name}/checkpoint";

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    aiofiles
    etils
    humanize
    importlib-resources
    jax
    msgpack
    nest-asyncio
    numpy
    protobuf
    psutil
    pyyaml
    simplejson
    tensorstore
    typing-extensions
  ];

  nativeCheckInputs = [
    chex
    google-cloud-logging
    mock
    optax
    portpicker
    pytest-xdist
    pytestCheckHook
    safetensors
    torch
  ];

  pythonImportsCheck = [
    "orbax"
    "orbax.checkpoint"
  ];

  disabledTests = [
    # Flaky
    # AssertionError: 2 not greater than 2.0046136379241943
    "test_async_mkdir_parallel"
    "test_async_mkdir_sequential"

    # AssertionError:
    # "Handler type string "(?:__main__|orbax.checkpoint._src.handlers.handler_type_registry_test)\.TestHandler" not found in the registry."
    # does not match
    # "'Handler type string "handler_type_registry_test.TestHandler" not found in the registry.'"
    "test_get_handler_type_not_found"
    "test_no_typestr"
    "test_register_duplicate_handler_type"

    # AssertionError: False is not true
    "test_register_and_get"
    "test_register_different_modules"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Probably failing because of a filesystem impurity
    # self.assertFalse(os.path.exists(dst_dir))
    # AssertionError: True is not false
    "test_create_snapshot"
  ];

  disabledTestPaths = [
    # import file mismatch:
    # imported module 'sharding_test' has this __file__ attribute:
    #   /build/source/checkpoint/orbax/checkpoint/_src/arrays/sharding_test.py
    # which is not the same as the test file we want to collect:
    #   /build/source/checkpoint/orbax/checkpoint/_src/metadata/sharding_test.py
    "orbax/checkpoint/_src/metadata/sharding_test.py"

    # Circular dependency with clu
    "orbax/checkpoint/_src/testing/benchmarks/array_handler_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/checkpoint_manager_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/checkpoint_manager_perf_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/checkpoint_policy_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/core/config_parsing_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/core/core_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/core/metric_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/emergency_checkpoint_manager_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/multihost_dispatchers_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/pytree_checkpoint_benchmark_test.py"
    "orbax/checkpoint/_src/testing/benchmarks/single_replica_benchmark_test.py"

    # E   absl.flags._exceptions.DuplicateFlagError: The flag 'num_processes' is defined twice.
    # First from multiprocess_test, Second from orbax.checkpoint._src.testing.multiprocess_test.
    # Description from first occurrence: Number of processes to use.
    # https://github.com/google/orbax/issues/1580
    "orbax/checkpoint/_src/testing/multiprocess_test.py"
    "orbax/checkpoint/experimental/emergency/"

    # ValueError: Distributed system is not available; please initialize it via `jax.distributed.initialize()` at the start of your program.
    "orbax/checkpoint/_src/handlers/array_checkpoint_handler_test.py"

    # import file mismatch:
    # imported module 'registry_test' has this __file__ attribute:
    #   /build/source/checkpoint/orbax/checkpoint/experimental/v1/_src/layout/registry_test.py
    # which is not the same as the test file we want to collect:
    #   /build/source/checkpoint/orbax/checkpoint/experimental/v1/_src/serialization/registry_test.py
    # HINT: remove __pycache__ / .pyc files and/or use a unique basename for your test file module
    "orbax/checkpoint/experimental/v1/_src/serialization/registry_test.py"

    # E   FileNotFoundError: [Errno 2] No such file or directory:
    # '/build/absl_testing/DefaultSnapshotTest/runTest/root/path/to/source/data.txt'
    "orbax/checkpoint/_src/path/snapshot/snapshot_test.py"

    # Circular dependency flax
    "orbax/checkpoint/_src/metadata/empty_values_test.py"
    "orbax/checkpoint/_src/metadata/tree_rich_types_test.py"
    "orbax/checkpoint/_src/metadata/tree_test.py"
    "orbax/checkpoint/_src/testing/test_tree_utils.py"
    "orbax/checkpoint/_src/tree/parts_of_test.py"
    "orbax/checkpoint/_src/tree/structure_utils_test.py"
    "orbax/checkpoint/_src/tree/utils_test.py"
    "orbax/checkpoint/checkpoint_manager_test.py"
    "orbax/checkpoint/single_host_test.py"
    "orbax/checkpoint/transform_utils_test.py"
  ];

  meta = {
    description = "Orbax provides common utility libraries for JAX users";
    homepage = "https://github.com/google/orbax/tree/main/checkpoint";
    changelog = "https://github.com/google/orbax/blob/v${version}/checkpoint/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
