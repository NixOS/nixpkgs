{ lib, buildPythonPackage, fetchPypi, numpy, scipy, six }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02ba0a3b31ed89c4b0c21d55ba7d87529097d56f394e3850b6d3c9e6c63ce7ae";
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
