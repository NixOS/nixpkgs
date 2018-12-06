{ lib, buildPythonPackage, fetchPypi, numpy, h5py }:

buildPythonPackage rec {
  pname = "Keras_Applications";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a03af60ddc9c5afdae4d5c9a8dd4ca857550e0b793733a5072e0725829b87017";
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
