{ lib, buildPythonPackage, fetchPypi, numpy, h5py }:

buildPythonPackage rec {
  pname = "Keras_Applications";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yk9brcvr96s1slpgj9vr6np7fk8limcrw9v2pjq72c6k0mpnq30";
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
