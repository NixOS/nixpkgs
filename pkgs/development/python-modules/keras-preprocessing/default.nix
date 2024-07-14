{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  six,
  scipy,
  pillow,
  pytest,
  keras,
}:

buildPythonPackage rec {
  pname = "keras-preprocessing";
  version = "1.1.2";

  src = fetchPypi {
    pname = "Keras_Preprocessing";
    inherit version;
    hash = "sha256-rdglZ8UMi8ZIwUGVv1RKXOfB92dhU2lWw9KXiXAXnvM=";
  };

  propagatedBuildInputs = [
    # required
    numpy
    six
    # optional
    scipy
    pillow
  ];

  nativeCheckInputs = [
    pytest
    keras
  ];

  checkPhase = ''
    py.test tests/
  '';

  # Cyclic dependency: keras-preprocessing's tests require Keras, which requires keras-preprocessing
  doCheck = false;

  meta = with lib; {
    description = "Easy data preprocessing and data augmentation for deep learning models";
    homepage = "https://github.com/keras-team/keras-preprocessing";
    license = licenses.mit;
  };
}
