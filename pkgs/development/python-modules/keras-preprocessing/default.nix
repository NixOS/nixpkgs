{ lib, buildPythonPackage, fetchPypi, numpy, six, scipy, pillow, pytest, Keras }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e669aa713727f0bc08f756616f64e0dfa75d822226cfc0dcf33297ab05cef7d";
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
