{ stdenv, lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0ca2458c60d9711edf4291230b31795307ad3781cb6232ff4792b53c8f55123";
  };

  checkInputs = [
    pytest
    pytestcov
    pytestpep8
    pytest_xdist
  ];

  propagatedBuildInputs = [
    six pyyaml numpy scipy
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
