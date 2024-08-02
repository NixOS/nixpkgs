{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jax,
  jaxlib,
  keras,
  numpy,
  parameterized,
  pillow,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
  tensorboard,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "objax";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "objax";
    rev = "refs/tags/v${version}";
    hash = "sha256-WD+pmR8cEay4iziRXqF3sHUzCMBjmLJ3wZ3iYOD+hzk=";
  };

  patches = [
    # Issue reported upstream: https://github.com/google/objax/issues/270
    ./replace-deprecated-device_buffers.patch
  ];

  build-system = [ setuptools ];

  # Avoid propagating the dependency on `jaxlib`, see
  # https://github.com/NixOS/nixpkgs/issues/156767
  buildInputs = [ jaxlib ];

  dependencies = [
    jax
    numpy
    parameterized
    pillow
    scipy
    tensorboard
  ];

  pythonImportsCheck = [ "objax" ];

  # This is necessay to ignore the presence of two protobufs version (tensorflow is bringing an
  # older version).
  catchConflicts = false;

  nativeCheckInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  pytestFlagsArray = [ "tests/*.py" ];

  disabledTests = [
    # Test requires internet access for prefetching some weights
    "test_pretrained_keras_weight_0_ResNet50V2"
    # ModuleNotFoundError: No module named 'tree'
    "TestResNetV2Pretrained"
  ];

  meta = with lib; {
    description = "Machine learning framework that provides an Object Oriented layer for JAX";
    homepage = "https://github.com/google/objax";
    changelog = "https://github.com/google/objax/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
    # Tests test_syncbn_{0,1,2}d and other tests from tests/parallel.py fail
    broken = true;
  };
}
