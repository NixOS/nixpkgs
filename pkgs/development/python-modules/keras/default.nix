{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  dm-tree,
  h5py,
  markdown-it-py,
  ml-dtypes,
  namex,
  numpy,
  optree,
  packaging,
  rich,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    rev = "refs/tags/v${version}";
    hash = "sha256-P/TRczWi/prv5D0/I6yLChIDfc6QdGcRSaF4Dd1Iowk=";
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
    packaging
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
    changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NikolaMandic ];
  };
}
