{
  lib,
  absl-py,
  buildPythonPackage,

  # build-system
  flit-core,

  # dependencies
  etils,
  fetchPypi,
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

  # checks
  google-cloud-logging,
  mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "orbax-checkpoint";
  version = "0.5.20";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "orbax_checkpoint";
    inherit version;
    hash = "sha256-V91BdeaYqMSVeZGrfmwZ17OoeSrnByuc0rJnzls0iE0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    absl-py
    etils
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
    google-cloud-logging
    mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "orbax"
    "orbax.checkpoint"
  ];

  disabledTestPaths = [
    # Circular dependency flax
    "orbax/checkpoint/transform_utils_test.py"
    "orbax/checkpoint/utils_test.py"
  ];

  meta = {
    description = "Orbax provides common utility libraries for JAX users";
    homepage = "https://github.com/google/orbax/tree/main/checkpoint";
    changelog = "https://github.com/google/orbax/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
