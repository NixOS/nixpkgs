{ lib, buildPythonPackage, fetchPypi, numpy, six, scipy, pillow, pytest, Keras }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r98nm4k1svsqjyaqkfk23i31bl1kcfcyp7094yyj3c43phfp3as";
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
    homepage = https://github.com/keras-team/keras-preprocessing;
    license = licenses.mit;
  };
}
