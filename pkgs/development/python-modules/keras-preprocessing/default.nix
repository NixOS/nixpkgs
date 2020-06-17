{ lib, buildPythonPackage, fetchPypi, numpy, six, scipy, pillow, pytest, Keras }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "add82567c50c8bc648c14195bf544a5ce7c1f76761536956c3d2978970179ef3";
  };

  propagatedBuildInputs = [
    # required
    numpy six
    # optional
    scipy pillow
  ];

  checkInputs = [
    pytest Keras
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
