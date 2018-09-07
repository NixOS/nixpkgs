{ lib, buildPythonPackage, fetchPypi, numpy, h5py }:

buildPythonPackage rec {
  pname = "Keras_Applications";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26a7318b9d8d5be80d75ab08a1284aaf4b94125dd8271b18ca89791e16eb2cfc";
  };

  # Cyclic dependency: keras-applications requires keras, which requires keras-applications
  postPatch = ''
    sed -i "s/keras>=[^']*//" setup.py
  '';

  # No tests in PyPI tarball
  doCheck = false;

  propagatedBuildInputs = [ numpy h5py ];

  meta = with lib; {
    description = "Reference implementations of popular deep learning models";
    homepage = https://github.com/keras-team/keras-applications;
    license = licenses.mit;
  };
}
