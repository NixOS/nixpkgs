{ lib
, absl-py
, buildPythonPackage
, cached-property
, etils
, fetchPypi
, flit-core
, importlib-resources
, jax
, jaxlib
, msgpack
, nest-asyncio
, numpy
, protobuf
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pyyaml
, tensorstore
, typing-extensions
}:

buildPythonPackage rec {
  pname = "orbax-checkpoint";
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "orbax_checkpoint";
    inherit version;
    hash = "sha256-zry5byLxFzah+e52x4yIi6roU3Jox/9mY62cujB2xlU=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    absl-py
    cached-property
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
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "orbax"
  ];

  disabledTestPaths = [
    # Circular dependency flax
    "orbax/checkpoint/transform_utils_test.py"
    "orbax/checkpoint/utils_test.py"
  ];

  meta = with lib; {
    description = "Orbax provides common utility libraries for JAX users";
    homepage = "https://github.com/google/orbax/tree/main/checkpoint";
    changelog = "https://github.com/google/orbax/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [fab ];
  };
}
