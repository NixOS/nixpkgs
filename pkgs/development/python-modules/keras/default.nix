{ stdenv, lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml, h5py
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b8499d157af217f1a5ee33589e774127ebc3e266c833c22cb5afbb0ed1734bf";
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
