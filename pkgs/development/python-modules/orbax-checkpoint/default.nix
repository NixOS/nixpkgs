{
  lib,
  stdenv,
  absl-py,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  etils,
  humanize,
  importlib-resources,
  jax,
  msgpack,
  nest-asyncio,
  numpy,
  protobuf,
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
}:

buildPythonPackage rec {
  pname = "orbax-checkpoint";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "orbax";
    tag = "v${version}";
    hash = "sha256-2bnm9D+ywhploTmtZ+frwf8VuTjczBVN+wqcfe3x77I=";
  };

  sourceRoot = "${src.name}/checkpoint";

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    etils
    humanize
    importlib-resources
    jax
    msgpack
    nest-asyncio
    numpy
    protobuf
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
  ];

  pythonImportsCheck = [
    "orbax"
    "orbax.checkpoint"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Probably failing because of a filesystem impurity
    # self.assertFalse(os.path.exists(dst_dir))
    # AssertionError: True is not false
    "test_create_snapshot"
  ];

  disabledTestPaths = [
    # E   absl.flags._exceptions.DuplicateFlagError: The flag 'num_processes' is defined twice.
    # First from multiprocess_test, Second from orbax.checkpoint._src.testing.multiprocess_test.
    # Description from first occurrence: Number of processes to use.
    # https://github.com/google/orbax/issues/1580
    "orbax/checkpoint/experimental/emergency/"

    # Circular dependency flax
    "orbax/checkpoint/_src/metadata/empty_values_test.py"
    "orbax/checkpoint/_src/metadata/tree_rich_types_test.py"
    "orbax/checkpoint/_src/metadata/tree_test.py"
    "orbax/checkpoint/_src/testing/test_tree_utils.py"
    "orbax/checkpoint/_src/tree/utils_test.py"
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
