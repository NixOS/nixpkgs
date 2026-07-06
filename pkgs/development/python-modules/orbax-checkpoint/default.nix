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
  jax,
  msgpack,
  numpy,
  prometheus-client,
  protobuf,
  psutil,
  pyyaml,
  simplejson,
  tensorstore,
  typing-extensions,
  uvloop,

  # tests
  aiosqlite,
  chex,
  fastapi,
  google-cloud-logging,
  greenlet,
  httpx,
  mock,
  optax,
  portpicker,
  pytestCheckHook,
  safetensors,
  sqlalchemy,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "orbax-checkpoint";
  version = "0.11.40";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "orbax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z1T1mt12kdY6EMY+95m12kW9nHcGj77f87i4PY9ibBU=";
  };

  sourceRoot = "${finalAttrs.src.name}/checkpoint";

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    aiofiles
    etils
    humanize
    jax
    msgpack
    numpy
    prometheus-client
    protobuf
    psutil
    pyyaml
    simplejson
    tensorstore
    typing-extensions
    uvloop
  ]
  ++ etils.optional-dependencies.epath
  ++ etils.optional-dependencies.epy;

  nativeCheckInputs = [
    aiosqlite
    chex
    fastapi
    google-cloud-logging
    greenlet
    httpx
    mock
    optax
    portpicker
    pytestCheckHook
    safetensors
    sqlalchemy
    torch
  ];

  disabledTests = [
    # ValueError: Distributed system is not available; please initialize it via `jax.distributed.initialize()` at the start of your program.
    "NumpyHandlerTest"
    "SerializationTest"
    "SingleReplicaArrayHandlerTest"
    "UtilsTest"

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

    # IndexError: list index out of range
    "test_named_sharding"

    # ValueError: cannot reshape array of size 1 into shape (0,2)
    "test_get_leaf_memory_per_device"
    "test_memory_size"
    "test_number_of_broadcasts"
    "test_tree_memory_per_device"
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

    # Circular dependency with clu (and we should not run benchmarks anyway)
    "orbax/checkpoint/_src/testing/benchmarks/"

    # E   absl.flags._exceptions.DuplicateFlagError: The flag 'num_processes' is defined twice.
    # First from multiprocess_test, Second from orbax.checkpoint._src.testing.multiprocess_test.
    # Description from first occurrence: Number of processes to use.
    # https://github.com/google/orbax/issues/1580
    "orbax/checkpoint/_src/testing/multiprocess_test.py"
    "orbax/checkpoint/_src/testing/oss/multiprocess_test.py"
    "orbax/checkpoint/experimental/emergency/"

    # ImportError: cannot import name 'tiering_service_pb2' from
    # 'orbax.checkpoint.experimental.tiering_service.proto'
    # (the protobuf module is not generated from the .proto file)
    "orbax/checkpoint/experimental/tiering_service/server_test.py"

    # ValueError: Distributed system is not available; please initialize it via `jax.distributed.initialize()` at the start of your program.
    "orbax/checkpoint/_src/handlers/array_checkpoint_handler_test.py"
    "orbax/checkpoint/experimental/v1/_src/layout/safetensors_layout_multiprocess_test.py"

    # import file mismatch:
    # imported module 'registry_test' has this __file__ attribute:
    #   /build/source/checkpoint/orbax/checkpoint/experimental/v1/_src/layout/registry_test.py
    # which is not the same as the test file we want to collect:
    #   /build/source/checkpoint/orbax/checkpoint/experimental/v1/_src/serialization/registry_test.py
    # HINT: remove __pycache__ / .pyc files and/or use a unique basename for your test file module
    "orbax/checkpoint/experimental/v1/_src/serialization/registry_test.py"

    # import file mismatch:
    # imported module 'serialization_test' has this __file__ attribute:
    #   /build/source/checkpoint/orbax/checkpoint/_src/serialization/serialization_test.py
    # which is not the same as the test file we want to collect:
    #   /build/source/checkpoint/orbax/checkpoint/experimental/v1/_src/metadata/serialization_test.py
    "orbax/checkpoint/experimental/v1/_src/metadata/serialization_test.py"

    # E   FileNotFoundError: [Errno 2] No such file or directory:
    # '/build/absl_testing/DefaultSnapshotTest/runTest/root/path/to/source/data.txt'
    "orbax/checkpoint/_src/path/snapshot/snapshot_test.py"

    # Expects to run on 8 devices
    "orbax/checkpoint/_src/multihost/multihost_test.py"

    # Circular dependency flax
    "orbax/checkpoint/_src/checkpointers/async_checkpointer_test.py"
    "orbax/checkpoint/_src/checkpointers/checkpointer_test.py"
    "orbax/checkpoint/_src/handlers/pytree_checkpoint_handler_test.py"
    "orbax/checkpoint/_src/metadata/empty_values_test.py"
    "orbax/checkpoint/_src/metadata/tree_rich_types_test.py"
    "orbax/checkpoint/_src/metadata/tree_test.py"
    "orbax/checkpoint/_src/serialization/local_type_handlers_test.py"
    "orbax/checkpoint/_src/testing/test_tree_utils.py"
    "orbax/checkpoint/_src/tree/parts_of_test.py"
    "orbax/checkpoint/_src/tree/structure_utils_test.py"
    "orbax/checkpoint/_src/tree/utils_test.py"
    "orbax/checkpoint/checkpoint_manager_test.py"
    "orbax/checkpoint/experimental/v1/_src/handlers/pytree_handler_test.py"
    "orbax/checkpoint/single_host_test.py"
    "orbax/checkpoint/transform_utils_test.py"
    "orbax/checkpoint/_src/handlers/standard_checkpoint_handler_test.py"
  ];

  pythonImportsCheck = [
    "orbax"
    "orbax.checkpoint"
  ];

  meta = {
    description = "Orbax provides common utility libraries for JAX users";
    homepage = "https://github.com/google/orbax/tree/main/checkpoint";
    changelog = "https://github.com/google/orbax/blob/${finalAttrs.src.tag}/checkpoint/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
