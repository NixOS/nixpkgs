{ stdenv, lib, buildPythonPackage, fetchPypi
, pytest, pytestcov, pytestpep8, pytest_xdist
, six, numpy, scipy, pyyaml
}:

buildPythonPackage rec {
  pname = "Keras";
  version = "2.1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ca3a381523bad40a6922e88951a316664cb088fd01cea07e5ec8ada3327e3c7";
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
