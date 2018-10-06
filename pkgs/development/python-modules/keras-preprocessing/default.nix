{ lib, buildPythonPackage, fetchPypi, numpy, scipy, six }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef2e482c4336fcf7180244d06f4374939099daa3183816e82aee7755af35b754";
  };

  # Cyclic dependency: keras-preprocessing requires keras, which requires keras-preprocessing
  postPatch = ''
    sed -i "s/keras>=[^']*//" setup.py
  '';

  # No tests in PyPI tarball
  doCheck = false;

  propagatedBuildInputs = [ numpy scipy six ];

  meta = with lib; {
    description = "Easy data preprocessing and data augmentation for deep learning models";
    homepage = https://github.com/keras-team/keras-preprocessing;
    license = licenses.mit;
  };
}
