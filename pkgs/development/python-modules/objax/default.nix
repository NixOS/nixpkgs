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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "objax";
    rev = "refs/tags/v${version}";
    hash = "sha256-1/XmxFZfU+XMD0Mlcv4xTUYZDwltAx1bZOlPuKWQQC0=";
  };

  patches = [
    (fetchpatch {  # https://github.com/google/objax/pull/266
      url = "https://github.com/google/objax/pull/266/commits/a1bcb71ebd92c94fec98222349d7cd57048e541d.patch";
      hash = "sha256-MO9/LAxbghjhRU8sbYWm3xa4RPuU+5m74YU3n3hJ09s=";
    })
  ];

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
