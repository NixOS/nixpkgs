{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jaxlib
, jax
, numpy
, parameterized
, pillow
, scipy
, tensorboard
, keras
, pytestCheckHook
, tensorflow
}:

buildPythonPackage rec {
  pname = "objax";
  version = "1.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = "objax";
    rev = "refs/tags/v${version}";
    hash = "sha256-WD+pmR8cEay4iziRXqF3sHUzCMBjmLJ3wZ3iYOD+hzk=";
  };

  # Avoid propagating the dependency on `jaxlib`, see
  # https://github.com/NixOS/nixpkgs/issues/156767
  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    jax
    numpy
    parameterized
    pillow
    scipy
    tensorboard
  ];

  pythonImportsCheck = [
    "objax"
  ];

  # This is necessay to ignore the presence of two protobufs version (tensorflow is bringing an
  # older version).
  catchConflicts = false;

  nativeCheckInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  pytestFlagsArray = [
    "tests/*.py"
  ];

  disabledTests = [
    # Test requires internet access for prefetching some weights
    "test_pretrained_keras_weight_0_ResNet50V2"
  ];

  meta = with lib; {
    description = "Objax is a machine learning framework that provides an Object Oriented layer for JAX.";
    homepage = "https://github.com/google/objax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
