{ lib, buildPythonPackage, fetchPypi, numpy, h5py }:

buildPythonPackage rec {
  pname = "Keras_Applications";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c95300328630ae74fb0828b6fa38269a25c0228a02f1e5181753bfd48961f49";
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
