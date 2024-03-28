{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, absl-py
, dm-tree
, h5py
, markdown-it-py
, ml-dtypes
, namex
, numpy
, optree
, rich
, tensorflow
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.1.1";
  disabled = pythonOlder "3.9";

  pyproject = true;
  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    rev = "refs/tags/v${version}";
    hash = "sha256-QcvG9bgdVJDnufNNdtz+qAAoiqh+uqDCxT1KYDjtaFs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = with lib; {
    description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
    homepage = "https://keras.io";
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
