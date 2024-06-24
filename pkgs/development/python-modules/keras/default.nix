{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  absl-py,
  dm-tree,
  h5py,
  markdown-it-py,
  ml-dtypes,
  namex,
  numpy,
  optree,
  rich,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.3.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    rev = "refs/tags/v${version}";
    hash = "sha256-hhY28Ocv4zacZiwFflJtufKpeKfH1MD1PZJ+NTJfpH0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    dm-tree
    h5py
    markdown-it-py
    ml-dtypes
    namex
    numpy
    optree
    rich
    tensorflow
  ];

  pythonImportsCheck = [
    "keras"
    "keras._tf_keras"
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = {
    description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
    homepage = "https://keras.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NikolaMandic ];
  };
}
