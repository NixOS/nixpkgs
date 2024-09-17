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
  jaxlib,
  msgpack,
  nest-asyncio,
  numpy,
  protobuf,
  pyyaml,
  tensorstore,
  typing-extensions,

  # tests
  chex,
  google-cloud-logging,
  mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "orbax-checkpoint";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "orbax";
    rev = "refs/tags/v${version}";
    hash = "sha256-xd75/AKBFUdA6a8sQnCB2rVbHl/Foy4LTb07jnwrTjA=";
  };

  sourceRoot = "${src.name}/checkpoint";

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    etils
    humanize
    importlib-resources
    jax
    jaxlib
    msgpack
    nest-asyncio
    numpy
    protobuf
    pyyaml
    tensorstore
    typing-extensions
  ];

  nativeCheckInputs = [
    chex
    google-cloud-logging
    mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "orbax"
    "orbax.checkpoint"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Probably failing because of a filesystem impurity
    # self.assertFalse(os.path.exists(dst_dir))
    # AssertionError: True is not false
    "test_create_snapshot"
  ];

  disabledTestPaths = [
    # Circular dependency flax
    "orbax/checkpoint/transform_utils_test.py"
    "orbax/checkpoint/utils_test.py"
  ];

  meta = {
    description = "Orbax provides common utility libraries for JAX users";
    homepage = "https://github.com/google/orbax/tree/main/checkpoint";
    changelog = "https://github.com/google/orbax/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
