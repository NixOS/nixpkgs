{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml, h5py
, keras-applications, keras-preprocessing
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fb448b95643a708d25d2394183a2f3a84eefb55fb64917152a46826990113ea";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy h5py
    keras-applications keras-preprocessing
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
