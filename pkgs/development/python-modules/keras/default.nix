{ stdenv, lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml, h5py
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c14af1081242c25617ade7eb62121d58d01f16e1e744bae9fc4f1f95a417716e";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy h5py
  ];

  # Couldn't get tests working
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Deep Learning library for Theano and TensorFlow";
    homepage = https://keras.io;
    license = licenses.mit;
    maintainers = with maintainers; [ NikolaMandic ];
  };
}
