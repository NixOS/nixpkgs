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
    sha256 = "add82567c50c8bc648c14195bf544a5ce7c1f76761536956c3d2978970179ef3";
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
