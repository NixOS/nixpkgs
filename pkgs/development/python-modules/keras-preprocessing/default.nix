{ lib, buildPythonPackage, fetchPypi, numpy, scipy, six }:

buildPythonPackage rec {
  pname = "Keras_Preprocessing";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5306554d2b454d825b36f35e327744f5477bd2ae21017f1a93b2097bed6757e";
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
